defmodule BuzzardPushNotifications do

    def pn_entity(device, token, timestamp) do
        {:pn_entity, device, token, timestamp}
    end

    def pn_entity_token(pn_entity) do
        {_, _, token, _} = pn_entity
        token
    end

    def init() do
        case :mnesia.create_table(:pn_entity, [{:attributes, [:device, :token, :timestamp]},
                                              {:disc_copies, [node()]}]) do
            {:atomic, :ok} -> :ok
            {:aborted, {:already_exists, _}} -> :ok
        end

        # store_token("device1", "2af328b8d5e70039e858a99a2495210d98fb48563211d8b14a576cda6af9cd19")
    end

    def store_token(device, token) do
        :mnesia.dirty_write(pn_entity(device, token, :os.timestamp()))
    end

    def send_notification() do
        :lists.foreach(fn(device) ->
                [pn_entity] = :mnesia.dirty_read(:pn_entity, device)
                message = APNS.Message.new
                message = message
                    |> Map.put(:token, pn_entity_token(pn_entity))
                    |> Map.put(:alert, "INTRUDER ALERT!")
                    |> Map.put(:badge, 1)
                APNS.push :app1_dev_pool, message
            end, :mnesia.dirty_all_keys(:pn_entity))
    end

end
