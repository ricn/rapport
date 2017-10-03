defmodule FontTest do
  use ExUnit.Case
  doctest Rapport.Font
  alias Rapport.Font

  describe "as_data" do
    test "must convert woff2 font to correct data" do
      woff2 = File.read!(Path.join(__DIR__, "fonts/font.woff2"))
      data = Font.as_data(woff2)
      assert data =~ "font/woff2;base64"
      assert data =~ "d09GMgABAAAAACZ4"
    end

    test "must raise error when font is invalid" do
      assert_raise ArgumentError, ~r/^Invalid font/, fn ->
        no_font = File.read!(Path.join(__DIR__, "fonts/no.font"))
        Font.as_data(no_font)
      end
    end
  end
end
