defmodule Mix.Tasks.SvgSprite do
  @moduledoc """

  """
  @shortdoc "Invokes svg_sprite using application config"

  use Mix.Task

  @impl true
  def run(_args) do
    Application.ensure_all_started(:phoenix_sprite_sheet)
    Mix.Task.reenable("svg_sprite")

    PhoenixSpriteSheet.get_config() |> 
    PhoenixSpriteSheet.Builder.build()
  end
end
