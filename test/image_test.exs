defmodule ImageTest do
  use ExUnit.Case
  doctest Rapport.Image
  alias Rapport.Image

  describe "as_data" do
    test "must convert png image to correct data" do
      png = File.read!(Path.join(__DIR__, "images/png.png"))
      data = Image.as_data(png)
      assert data =~ "image/png;base64"
      assert data =~ "iVBORw0KGgoAAAANSUhEUgAAA"
    end

    test "must convert jpeg image to correct data" do
      jpg = File.read!(Path.join(__DIR__, "images/jpg.jpg"))
      data = Image.as_data(jpg)
      assert data =~ "image/jpeg;base64"
      assert data =~ "/9j/"
    end

    test "must convert gif image to correct data" do
      jpg = File.read!(Path.join(__DIR__, "images/gif.gif"))
      data = Image.as_data(jpg)
      assert data =~ "image/gif;base64"
      assert data =~ "R0lGODl"
    end

    test "must raise error when image is not an image" do
      assert_raise ArgumentError, ~r/^Invalid image/, fn ->
        no_image = File.read!(Path.join(__DIR__, "images/no.image"))
        Image.as_data(no_image)
      end
    end
  end
end
