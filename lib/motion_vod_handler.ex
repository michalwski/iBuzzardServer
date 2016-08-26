defmodule :motion_vod_handler do
  @behaviour :cowboy_http_handler

  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    {:ok, req2} = :cowboy_req.reply(200, [], "test", req)
    {:ok, req2, state}
  end

  def terminate(_reason, req, state) do
    :ok
  end

end
