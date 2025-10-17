defmodule Rapport.Barcode do
  @moduledoc """
  Provides functionality for creating barcodes in various formats for use in reports.
  """

  @spec create(:code128 | :code39 | :code93 | :itf | :ean13, String.t(), keyword) :: String.t()
  @doc """
  Creates a barcode image (PNG) with the given text

  It expects the barcode type to be an :atom and it must be `:code39`, `:code93`, `code128` or `:itf`,
  otherwise `ArgumentError` will be raised.

  ## Options

    * `barcode_type` - The barcode type to use
    * `text` - The text to use to generate the barcode
  """
  def create(barcode_type, text, opts \\ []) when is_binary(text) do
    case barcode_type do
      :code39 ->
        create_barcode(text, opts, Barlix.Code39)

      :code93 ->
        create_barcode(text, opts, Barlix.Code93)

      :code128 ->
        create_barcode(text, opts, Barlix.Code128)

      :itf ->
        create_barcode(text, opts, Barlix.ITF)

      :ean13 ->
        create_barcode(text, opts, Barlix.EAN13)

      _ ->
        raise ArgumentError, message: "Invalid barcode type"
    end
  end

  defp create_barcode(text, opts, barlix_module) do
    {:ok, png} = barlix_module.encode!(text) |> Barlix.PNG.print(opts)
    IO.iodata_to_binary(png)
  end
end
