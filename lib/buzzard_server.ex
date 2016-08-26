defmodule BuzzardServer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    init_mnesia()
    init_cowboy()
    BuzzardPushNotifications.init()

    children = [
      #worker(BuzzardServer.Worker, [arg1, arg2, arg3]),
    ]

    opts = [strategy: :one_for_one, name: BuzzardServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def init_mnesia() do
    :mnesia.create_schema([node()])
    Application.start(:mnesia)
  end

  def init_cowboy() do
    {:ok, _} = Application.ensure_all_started(:cowboy)

    intrusion_dispatch = :cowboy_router.compile([
            {:_, [{"/intrusion_event", :intrusion_event_handler, []}]}
        ])
    device_token_dispatch = :cowboy_router.compile([
            {:_, [{"/device_token", :device_token_handler, []}]}
        ])

    :cowboy.start_http(:intrusion_event_listener, 10, [{:port, 7000}],
                       [{:env, [{:dispatch, intrusion_dispatch}]}])
    :cowboy.start_http(:device_token_listener, 10, [{:port, 9000}],
                       [{:env, [{:dispatch, device_token_dispatch}]}])

  end

end
