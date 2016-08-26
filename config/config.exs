# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :buzzard_server, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:buzzard_server, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
config :apns,
  # Here goes "global" config applied as default to all pools started if not overwritten by pool-specific value
  callback_module:    APNS.Callback,
  timeout:            30,
  feedback_interval:  1200,
  support_old_ios:    true,
  expiry:    60,
  # Here are pools configs. Any value from "global" config can be overwritten in any single pool config
  pools: [
    app1_dev_pool: [
      env: :dev,
      pool_size: 10,
      pool_max_overflow: 0,
      certfile: "iBuzzard.pem"
    ]

#    app1_prod_pool: [
#      env: :prod,
#      certfile: "/path/to/app1_prod.pem",
#      pool_size: 100,
#      pool_max_overflow: 0
#    ],
  ]
