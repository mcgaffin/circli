defmodule Circli.MixProject do
  use Mix.Project

  def project do
    [
      app: :circli,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: Circli.CLI],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:httpotion, :timex, :colixir],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:colixir, "~> 0.0.1"},
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.1"},
      {:tzdata, "~> 0.1.8", override: true},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
