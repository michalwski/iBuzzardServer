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
    case :mnesia.create_table(:motion, [{:disc_copies, [node]},
                                        {:attributes, [:start, :end]}]) do
      {:atomic, :ok} -> :ok
      {:aborted, {:already_exists, _}} -> :ok
    end
    {:ok, :undefined}
  end

  def handle_cast(:motion_detected, :undefined) do
    #TODO ask for frames
    Logger.info "start saving"
    timer_ref = set_timer()
    {:noreply, timer_ref}
  end

  def handle_cast(:motion_detected, TimerRef) do
    newtimerref = reset_timer(TimerRef)
    Logger.info "continue saving"
    {:noreply, newtimerref}
  end

  def handle_info(:motion_stopped, _) do
    ##
    Logger.info "stop saving"
    {:noreply, :undefined}
  end

  defp set_timer() do
    Process.send_after self(), :motion_stopped, :timer.seconds(10)
  end

  defp reset_timer(timerref) do
    Process.cancel_timer(timerref)
    set_timer()
  end


end
