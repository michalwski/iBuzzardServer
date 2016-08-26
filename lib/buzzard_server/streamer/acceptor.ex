defmodule BuzzardServer.Streamer.Acceptor do
  use GenServer

  alias BuzzardServer.Streamer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, sock} = :gen_tcp.listen(5000, [:binary, {:packet, 0}])
    GenServer.cast(__MODULE__, :accept)
    {:ok, sock}
  end

  def handle_cast(:accept, orig) do
    {:ok, sock} = :gen_tcp.accept(orig)
    :gen_tcp.controlling_process(sock, Process.whereis(Streamer))
    GenServer.cast(Streamer, {:new_socket, sock})
    GenServer.cast(__MODULE__, :accept)
    {:noreply, orig}
  end
end
