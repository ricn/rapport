defmodule Rapport.Barcode do

  @doc """
  Creates a barcode image (PNG) with the given text

  It expects the barcode type to be an :atom and it must be `:code39`, `:code93`, `code128` or `:itf`,
  otherwise `ArgumentError` will be raised.

  ## Options

    * `barcode_type` - The barcode type to use
    * `text` - The text to use to generate the barcode
  """
  def create(barcode_type, text, opts \\ []) do
    case barcode_type do
      :code39   -> create_code39(text, opts)
      :code93   -> create_code93(text, opts)
      :code128  -> create_code128(text, opts)
      :itf      -> create_itf(text, opts)
      _ -> raise ArgumentError, message: "Invalid barcode type"
    end
  end

  defp create_code39(text, opts) do
    out_file = generate_random_file()
    opts = Keyword.put(opts, :file, out_file)
    Barlix.Code39.encode!(text) |> Barlix.PNG.print(opts)
    png = File.read!(out_file)
    File.rm!(out_file)
    png
  end

  defp create_code93(text, opts) do
    out_file = generate_random_file()
    opts = Keyword.put(opts, :file, out_file)
    Barlix.Code93.encode!(text) |> Barlix.PNG.print(opts)
    png = File.read!(out_file)
    File.rm!(out_file)
    png
  end

  defp create_code128(text, opts) do
    out_file = generate_random_file()
    opts = Keyword.put(opts, :file, out_file)
    Barlix.Code128.encode!(text) |> Barlix.PNG.print(opts)
    png = File.read!(out_file)
    File.rm!(out_file)
    png
  end

  defp create_itf(text, opts) do
    out_file = generate_random_file()
    opts = Keyword.put(opts, :file, out_file)
    Barlix.Code128.encode!(text) |> Barlix.PNG.print(opts)
    png = File.read!(out_file)
    File.rm!(out_file)
    png
  end

  defp generate_random_file, do: Path.join([System.tmp_dir!, "barcode_#{UUID.uuid4()}.png"])
end
