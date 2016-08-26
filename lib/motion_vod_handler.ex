defmodule :motion_vod_handler do
  @behaviour :cowboy_http_handler

  def init(_type, req, _opts) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    {:ok, req2} = :cowboy_req.reply(200, [], format_rows, req)
    {:ok, req2, state}
  end

  def terminate(_reason, req, state) do
    :ok
  end

  def format_rows() do
    rows = IBuzzard.VideoSaver.read_all
    struct = for {start, ent} <- rows do
      {[{<<"start">>, DateTime.to_unix(start)} |
         case ent do
           :undefined -> [];
           _ -> [{<<"end">>, DateTime.to_unix(ent)}]
         end]}
    end
    :jiffy.encode(struct)
  end
end
