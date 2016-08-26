defmodule :intrusion_event_handler do
    @behaviour :cowboy_http_handler
    
    def init(_type, req, _opts) do
        {:ok, req, :no_state}
    end

    def handle(req, state) do
        {ok, req1} = :cowboy_req.reply(200, [], '{"status": "ok"}', req)
        {:ok, req1, state}
    end

    def terminate(_reason, req, state) do
        :ok
    end

end
