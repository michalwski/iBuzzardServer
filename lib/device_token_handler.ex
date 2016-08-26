defmodule :device_token_handler do
    @behaviour :cowboy_http_handler
    
    def init(_type, req, _opts) do
        {:ok, req, :no_state}
    end

    def handle(req, state) do
        {:ok, body, req1} = :cowboy_req.body(req)
        {proplist} = :jiffy.decode(body)
        device = :proplists.get_value("device", proplist)
        token = :proplists.get_value("token", proplist)
        BuzzardPushNotifications.store_token(device, token)
        {:ok, req2} = :cowboy_req.reply(200, [], '{"status": "ok"}', req1)
        {:ok, req2, state}
    end

    def terminate(_reason, req, state) do
        :ok
    end

end
