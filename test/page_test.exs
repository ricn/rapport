defmodule PageTest do
  use ExUnit.Case
  doctest Rapport.Page

  alias Rapport.Page
  alias Rapport
  @hello_template File.read!(Path.join(__DIR__, "templates/hello.html.eex"))

  describe "add_page" do
    test "add one page with template and fields" do
      report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Hello world"})

      assert length(report.pages) == 1
      assert List.first(report.pages).fields.hello == "Hello world"
    end

    test "add two pages with template and fields" do
      report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "One"})
        |> Rapport.add_page(@hello_template, %{hello: "Two"})

      assert length(report.pages) == 2
    end

    test "add one page with a Page struct" do
      report =
        Rapport.new
        |> Rapport.add_page(%Page{template: @hello_template, fields: %{hello: "Hello world"}})

      assert length(report.pages) == 1
      assert List.first(report.pages).fields.hello == "Hello world"
    end

    test "add two pages using Page structs" do
      report =
        Rapport.new
        |> Rapport.add_page(%Page{template: @hello_template, fields: %{hello: "One"}})
        |> Rapport.add_page(%Page{template: @hello_template, fields: %{hello: "Two"}})

      assert length(report.pages) == 2
    end
  end

  describe "add_pages" do
    test "add two pages" do
      list_of_pages = [
        %Page{template: @hello_template, fields: %{hello: "One"}},
        %Page{template: @hello_template, fields: %{hello: "Two"}}
      ]

      report =
        Rapport.new
        |> Rapport.add_pages(list_of_pages)

      assert length(report.pages) == 2
    end
  end
end
