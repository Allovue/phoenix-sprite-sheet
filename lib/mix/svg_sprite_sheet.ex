defmodule Mix.Tasks.SvgSpriteSheet do
  @moduledoc """

  """
  @shortdoc "Builds the SVG Sprite Sheet defined by the application configuration."

  use Mix.Task

  @impl true
  def run(_args) do
    Application.ensure_all_started(:phoenix_sprite_sheet)
    Mix.Task.reenable("svg_sprite_sheet")

    PhoenixSpriteSheet.get_config()
    |> PhoenixSpriteSheet.Builder.build()
  end
end
