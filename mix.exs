defmodule Stockfighter.Mixfile do
  use Mix.Project

  def project do
    [app: :stockfighter,
     version: "0.0.1",
     elixir: "~> 1.2",
     escript: [main_module: Stockfighter],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.8.0"}, {:poison, "~> 2.0"}]
  end
end
