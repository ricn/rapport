defmodule Rapport.Image do
  @spec as_data(String.t()) :: String.t()
  @doc """
  Converts an image to a base64 encoded string that can be embedded in a image tag:

  <img alt="Embedded Image" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIA..." />

  Supported image types are JPEG, PNG and GIF.
  ## Options

    * `image` - Image binary
  """
  def as_data(image) do
    mime_type = detect_mime_type(image)
    encoded_image = Base.encode64(image)
    "data:#{mime_type};base64,#{encoded_image}"
  end

  defp detect_mime_type(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>> <> _), do: "image/png"
  defp detect_mime_type(<<0xFF, 0xD8, 0xFF>> <> _), do: "image/jpeg"
  defp detect_mime_type("GIF87a" <> _), do: "image/gif"
  defp detect_mime_type("GIF89a" <> _), do: "image/gif"
  defp detect_mime_type(_), do: raise(ArgumentError, message: "Invalid image")
end
