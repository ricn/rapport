defmodule Rapport.Font do
  @doc """
  Converts a font file (woff2) to a base64 encoded string that can be to embedded:

  @font-face {
    src: url(data:font/woff2;charset=utf-8;base64,d09GRgA...kAAA==) format('woff')
  }

  Only woff2 format is supported at the moment

  ## Options

    * `font` - Font binary
  """
  def as_data(font) do
    mime_type = detect_mime_type(font)
    encoded_font = Base.encode64(font)
    "data:#{mime_type};base64,#{encoded_font}"
  end

  defp detect_mime_type("wOF2" <> _), do: "font/woff2"
  defp detect_mime_type(_), do: raise(ArgumentError, message: "Invalid font")
end
