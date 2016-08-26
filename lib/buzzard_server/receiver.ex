defmodule BuzzardServer.Receiver do
  use GenServer

  require Logger

  alias BuzzardServer.Streamer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, sock} = :gen_tcp.listen(8000, [:binary, {:packet, 0}])
    GenServer.cast(__MODULE__, :accept)
    {:ok, {nil, sock}}
  end

  def handle_cast(:accept, {_sock, orig}) do
    {:ok, sock} = :gen_tcp.accept(orig)
    {:noreply, {sock, orig}}
  end

  def handle_info({:tcp, sock, data}, {sock, orig}) do
    Streamer.send(data)
    {:noreply, {sock, orig}}
  end

  def handle_info({:tcp_closed, sock}, {sock, orig}) do
    GenServer.cast(__MODULE__, :accept)
    {:noreply, {nil, orig}}
  end
end
