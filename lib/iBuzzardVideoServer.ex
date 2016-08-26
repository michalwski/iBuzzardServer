defmodule IBuzzard.VideoSaver do
  use GenServer

  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def motion_detected() do
    GenServer.cast(__MODULE__, :motion_detected)
  end

  def read_all() do
    recs = :lists.reverse(:lists.sort(:ets.tab2list(:motion)))
    for {:motion, start, ent} <- recs do
      {start, ent}
    end
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
    :ok = BuzzardPushNotifications.send_notification()
    timer_ref = set_timer()
    motion_rec = {:motion, DateTime.utc_now, :undefined}
    :mnesia.dirty_write(motion_rec)
    {:noreply, {timer_ref, motion_rec}}
  end

  def handle_cast(:motion_detected, {timer_ref, motion_rec}) do
    newtimerref = reset_timer(timer_ref)
    Logger.info "continue saving"
    {:noreply, {newtimerref, motion_rec}}
  end

  def handle_info(:motion_stopped, {_, {:motion, start, _}}) do
    ##
    Logger.info "stop saving"
    :mnesia.dirty_write({:motion, start, DateTime.utc_now})
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
