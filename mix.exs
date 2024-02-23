defmodule PhoenixSpriteSheet.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_sprite_sheet,
      version: "0.2.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :phoenix, :phoenix_live_view, :file_system],
      mod: {PhoenixSpriteSheet, []},
      env: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:file_system, "~> 0.2.1 or ~> 0.3"}
    ]
  end
end
