defmodule BuzzardPushNotifications do

    def pn_entity(device, token, timestamp) do
        {:pn_entity, device, token, timestamp}
    end

    def pn_entity_token({_, _, token, _}) do
        token
    end

    def init() do
        case :mnesia.create_table(:pn_entity, [{:attributes, [:device, :token, :timestamp]},
                                              {:disc_copies, [node()]}]) do
            {:atomic, :ok} -> :ok
            {:aborted, {:already_exists, _}} -> :ok
        end
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
                    |> Map.put(:sound, "buzzard.wav")
                    |> Map.put(:badge, 1)
                APNS.push :app1_dev_pool, message
            end, :mnesia.dirty_all_keys(:pn_entity))
    end

end
