defmodule Rapport.Image do
  def as_data(image) do
    mime_type = detect_mime_type(image)
    encode_type = "base64"
    encoded_image = Base.encode64(image)
    "data:#{mime_type};base64,#{encoded_image}"
  end

  defp detect_mime_type(<< 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A >> <> _), do: "image/png"
  defp detect_mime_type(<< 0xFF, 0xD8, 0xFF >> <> _), do: "image/jpeg"
  defp detect_mime_type("GIF87a" <> _), do: "image/gif"
  defp detect_mime_type("GIF89a" <> _), do: "image/gif"
end
