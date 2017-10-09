defmodule PageNumberingTest do
  use ExUnit.Case
  doctest Rapport.PageNumbering

  alias Rapport

  @hello_template File.read!(Path.join(__DIR__, "templates/hello.html.eex"))

  describe "add_page_numbers" do
    test "add page numbers without options" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Page 1"})
        |> Rapport.add_page(@hello_template, %{hello: "Page 2"})
        |> Rapport.add_page_numbers # bottom right
        |> Rapport.generate_html
        assert html_report =~ "<span class='page-numbering bottom_right'>1</span>"
        assert html_report =~ "<span class='page-numbering bottom_right'>2</span>"
    end

    test "add page numbers to bottom left corner" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Page 1"})
        |> Rapport.add_page(@hello_template, %{hello: "Page 2"})
        |> Rapport.add_page_numbers(:bottom_left)
        |> Rapport.generate_html
        assert html_report =~ "<span class='page-numbering bottom_left'>1</span>"
        assert html_report =~ "<span class='page-numbering bottom_left'>2</span>"
    end

    test "add page numbers to top right corner" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Page 1"})
        |> Rapport.add_page(@hello_template, %{hello: "Page 2"})
        |> Rapport.add_page_numbers(:top_right)
        |> Rapport.generate_html
        assert html_report =~ "<span class='page-numbering top_right'>1</span>"
        assert html_report =~ "<span class='page-numbering top_right'>2</span>"
    end

    test "add page numbers to top left corner" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Page 1"})
        |> Rapport.add_page(@hello_template, %{hello: "Page 2"})
        |> Rapport.add_page_numbers(:top_left)
        |> Rapport.generate_html
        assert html_report =~ "<span class='page-numbering top_left'>1</span>"
        assert html_report =~ "<span class='page-numbering top_left'>2</span>"
    end

    test "raise error when invalid page number position is used" do
      assert_raise ArgumentError, ~r/^Invalid page number position/, fn ->
        Rapport.new
        |> Rapport.add_page_numbers(:middle_middle)
      end
    end

    test "format page numbers as 1 (2)" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Page 1"})
        |> Rapport.add_page(@hello_template, %{hello: "Page 2"})
        |> Rapport.add_page_numbers(:bottom_right, fn(current_page, total_pages) -> "#{current_page} (#{total_pages})" end)
        |> Rapport.generate_html
        assert html_report =~ "<span class='page-numbering bottom_right'>1 (2)</span>"
        assert html_report =~ "<span class='page-numbering bottom_right'>2 (2)</span>"
    end

    test "format page numbers as 1 of 2" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Page 1"})
        |> Rapport.add_page(@hello_template, %{hello: "Page 2"})
        |> Rapport.add_page_numbers(:bottom_right, fn(current_page, total_pages) -> "#{current_page} of #{total_pages}" end)
        |> Rapport.generate_html
        assert html_report =~ "<span class='page-numbering bottom_right'>1 of 2</span>"
        assert html_report =~ "<span class='page-numbering bottom_right'>2 of 2</span>"
    end

    test "must not add page numbers if we don't want them" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Page 1"})
        |> Rapport.add_page(@hello_template, %{hello: "Page 2"})
        |> Rapport.generate_html

        assert !String.contains?(html_report, "<span class='page-numbering bottom_left'>1</span>")
        assert !String.contains?(html_report, "<span class='page-numbering bottom_left'>2</span>")
    end
  end
end
