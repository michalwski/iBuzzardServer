defmodule BuzzardServer.Mixfile do
  use Mix.Project

  def project do
    [app: :buzzard_server,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :apns],
     mod: {BuzzardServer, []}]
  end

  defp deps do
    [
        {:cowboy, git: "https://github.com/ninenines/cowboy.git", tag: "1.0.4"},
        {:apns, "~> 0.9.4"},
        {:jiffy, "~> 0.14.7"}
    ]
  end
end
