defmodule PhoenixSpriteSheet.Builder do
  require Logger

  @suffix ".svg"
  @opening ~s(<?xml version="1.0" encoding="utf-8"?>
  <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
)
  @closing ~s(
</svg>)

  def build(%{dirs: dirs, id_prefix: prefix, output_path: out}) do
    list_all_svgs(dirs)
    |> build_id_map(prefix)
    |> generate_xml
    |> write_file(out)

    Logger.info("Wrote #{out}")
  end

  defp list_all_svgs(dirs) do
    Enum.flat_map(dirs, &ls_r(&1))
    |> Enum.filter(&String.ends_with?(&1, @suffix))
    |> Enum.sort()
  end

  def build_id_map(files, ""), do: build_id_map(files, nil)

  def build_id_map(files, prefix) do
    Enum.map(files, fn file ->
      filename = Path.basename(file, ".svg")
      ident = if prefix, do: "#{prefix}-#{filename}", else: filename
      {ident, file}
    end)
  end

  def generate_xml(svgs) do
    @opening <>
      Enum.join(Enum.map(svgs, &file_to_string(&1)), "\n") <>
      @closing
  end

  def write_file(xml, path) do
    File.write!(path, xml)
    path
  end

  def file_to_string({ident, full_path}) do
    File.read!(full_path)
    # take a swing for the fences and hope we have valid html
    |> String.replace("xmlns=", ~s( id="#{ident}" xmlns=))
  end

  defp ls_r(path) do
    cond do
      File.regular?(path) ->
        [path]

      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&ls_r/1)
        |> Enum.concat()

      true ->
        []
    end
  end
end
