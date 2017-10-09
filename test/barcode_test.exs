defmodule BarcodeTest do
  use ExUnit.Case
  doctest Rapport.Barcode
  alias Rapport.Barcode

  describe "create" do
    test "must create code39 barcode" do
      binary = Barcode.create(:code39, "201731010101")
      assert  << 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A >> <> _ = binary
    end

    test "must create code93 barcode" do
      binary = Barcode.create(:code93, "201731010101")
      assert  << 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A >> <> _ = binary
    end

    test "must create code128 barcode" do
      binary = Barcode.create(:code128, "201731010101")
      assert  << 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A >> <> _ = binary
    end

    test "must create ITF barcode" do
      binary = Barcode.create(:itf, "201731010101")
      assert  << 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A >> <> _ = binary
    end

    test "must raise error when barcode type is invalid" do
      assert_raise ArgumentError, ~r/^Invalid barcode type/, fn ->
        Barcode.create(:code3000, "201731010101")
      end
    end
  end
end
