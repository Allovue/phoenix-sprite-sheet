defmodule PhoenixSpriteSheet.Worker do
  @monitor :phoenix_sprite_sheet_file_monitor
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    %{dirs: dirs} = config = PhoenixSpriteSheet.get_config()
    opts = [name: @monitor, dirs: dirs]

    case FileSystem.start_link(opts) do
      {:ok, fs_pid} ->
        FileSystem.subscribe(fs_pid)

      other ->
        Logger.warn(
          "PhoenixSpriteSheet could not start FileSystem. This is ok if you do are not using phoenix_live_reload."
        )

        other
    end

    {:ok, config}
  end

  def handle_info({:file_event, _fs_pid, {path, _meta}}, state) do
    if String.ends_with?(path, ".svg") do
      GenServer.cast(self(), {:rebuild, path})
    end

    {:noreply, state}
  end

  def handle_cast(:rebuild, state) do
    Logger.info("Rebuilding all")
    PhoenixSpriteSheet.Builder.build(state)
    {:noreply, state}
  end

  def handle_cast({:rebuild, path}, state) do
    Logger.info("#{path} changed")
    PhoenixSpriteSheet.Builder.build(state)
    {:noreply, state}
  end
end
