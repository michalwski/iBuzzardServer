defmodule IBuzzard.VideoSaver do
  use GenServer

  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def motion_detected() do
    GenServer.cast(__MODULE__, :motion_detected)
  end

  def init([]) do
    {:ok, :undefined}
  end

  def handle_cast(:motion_detected, undefined) do
    #TODO ask for frames
    Logger.info "start saving"
    TimerRef = set_timer()
    {:noreply, TimerRef}
  end

  def handle_cast(:motion_detected, TimerRef) do
    NewTimerRef = reset_timer(TimerRef)
    Logger.info "continue saving"
    {:noreply, NewTimerRef}
  end

  def handle_info(:motion_stopped, _) do
    ##
    Logger.info "stop saving"
    {:noreply, :undefined}
  end

  defp set_timer() do
    Process.send_after self(), :motion_stopped, :timer.seconds(10)
  end

  defp reset_timer(TimerRef) do
    Process.cancel_timer(TimerRef)
    set_timer()
  end


end
