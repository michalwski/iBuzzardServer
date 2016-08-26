defmodule BuzzardServer.Streamer do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def send(data) do
    GenServer.cast(__MODULE__, {:send, data})
  end


  
  def handle_cast({:send, data}, nil) do
    {:noreply, nil}
  end

  def handle_cast({:send, data}, sock) do
    :gen_tcp.send(sock, data)
    {:noreply, sock}
  end
  
  def handle_cast({:new_socket, sock}, old) do
    if old != nil, do: :gen_tcp.close(old)
    {:noreply, sock}
  end

  def handle_info({:tcp_closed, _}, _) do
    {:noreply, nil}
  end
  
end
