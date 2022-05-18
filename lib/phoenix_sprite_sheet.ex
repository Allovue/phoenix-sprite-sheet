defmodule PhoenixSpriteSheet do
  use Application
  require Logger

  def start(_, _) do
    children = [{PhoenixSpriteSheet.Worker, []}]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def get_config do
    dirs =
      Application.get_env(:phoenix_sprite_sheet, :dirs, [""])
      |> Enum.map(&Path.absname/1)

    output = Application.get_env(:phoenix_sprite_sheet, :output_path, ["priv/static/sheet.svg"])
    prefix = Application.get_env(:phoenix_sprite_sheet, :prefix, nil)

    %{dirs: dirs, output_path: output, id_prefix: prefix}
  end
end
