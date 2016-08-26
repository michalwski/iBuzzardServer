defmodule BuzzardServer do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    init_cowboy()

    children = [
      #worker(BuzzardServer.Worker, [arg1, arg2, arg3]),
    ]

    opts = [strategy: :one_for_one, name: BuzzardServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def init_cowboy() do
    {:ok, _} = Application.ensure_all_started(:cowboy)

    intrusion_dispatch = :cowboy_router.compile([
            {:_, [{"/intrusion_event", :intrusion_event_handler, []}]}
        ])

    :cowboy.start_http(:intrusion_event_listener, 10, [{:port, 7000}],
                       [{:env, [{:dispatch, intrusion_dispatch}]}])
  end

end
