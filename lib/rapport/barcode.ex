defmodule Rapport.Barcode do

  @doc """
  Creates a barcode image (PNG) with the given text

  It expects the barcode type to be an :atom and it must be `:code39`, `:code93`, `code128` or `:itf`,
  otherwise `ArgumentError` will be raised.

  ## Options

    * `barcode_type` - The barcode type to use
    * `text` - The text to use to generate the barcode
  """
  def create(barcode_type, text) do
    case barcode_type do
      :code39   -> create_code39(text)
      :code93   -> create_code93(text)
      :code128  -> create_code128(text)
      :itf      -> create_itf(text)
      _ -> raise ArgumentError, message: "Invalid barcode type"
    end
  end

  defp create_code39(text) do
    out_file = generate_random_file()
    Barlix.Code39.encode!(text) |> Barlix.PNG.print(file: out_file)
    File.read!(out_file)
  end

  defp create_code93(text) do
    out_file = generate_random_file()
    Barlix.Code93.encode!(text) |> Barlix.PNG.print(file: out_file)
    File.read!(out_file)
  end

  defp create_code128(text) do
    out_file = generate_random_file()
    Barlix.Code128.encode!(text) |> Barlix.PNG.print(file: out_file)
    File.read!(out_file)
  end

  defp create_itf(text) do
    out_file = generate_random_file()
    Barlix.Code128.encode!(text) |> Barlix.PNG.print(file: out_file)
    File.read!(out_file)
  end

  defp generate_random_file, do: Path.join([System.tmp_dir!, "barcode_#{UUID.uuid4()}.png"])
end
