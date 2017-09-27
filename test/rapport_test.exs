defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")
  @two_fields_template Path.join(__DIR__, "templates/two_fields.html.eex")
  @list_template Path.join(__DIR__, "templates/list.html.eex")
  @list_map_template Path.join(__DIR__, "templates/list_map.html.eex")
  @empty_template Path.join(__DIR__, "templates/empty.html.eex")

  describe "new" do

    test "simplest possible" do
      report = Rapport.new
      assert is_map(report)
      assert Map.has_key?(report, :title)
      assert Map.get(report, :title) == "Report"
      assert Map.has_key?(report, :paper_size)
      assert Map.has_key?(report, :rotation)
      assert Map.has_key?(report, :pages)
      assert is_list(Map.get(report, :pages))
    end

    test "set title" do
      report = Rapport.new("My report")
      assert Map.get(report, :title) == "My report"
    end

    test "must raise argument error when paper size is invalid" do
      assert_raise ArgumentError, ~r/^Invalid paper size/, fn ->
        Rapport.new(@empty_template, :WRONG)
      end
    end

    test "must raise argument error when rotation is invalid" do
      assert_raise ArgumentError, ~r/^Invalid rotation/, fn ->
        Rapport.new(@empty_template, :A4, :nope)
      end
    end

    test "must allow inline template" do
      inline_template = """
      <section class="sheet padding-10mm">
        <article><%= @hello %></article>
      </section>
      """
      html_report =
        Rapport.new
        |> Rapport.add_page(inline_template, %{hello: "Inline template"})
        |> Rapport.generate_html

      assert html_report =~ "Inline template"
    end

    test "A4 portrait" do
      html_report =
        Rapport.new(@empty_template, :A4, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A4}</style>"
      assert html_report =~ "<body class=\"A4\">"
    end

    test "A4 landscape" do
      html_report =
        Rapport.new(@empty_template, :A4, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A4 landscape}</style>"
      assert html_report =~ "<body class=\"A4 landscape\">"
    end

    test "A3 portrait" do
      html_report =
        Rapport.new(@empty_template, :A3, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A3}</style>"
      assert html_report =~ "<body class=\"A3\">"
    end

    test "A3 landscape" do
      html_report =
        Rapport.new(@empty_template, :A3, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A3 landscape}</style>"
      assert html_report =~ "<body class=\"A3 landscape\">"
    end

    test "A5 portrait" do
      html_report =
        Rapport.new(@empty_template, :A5, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A5}</style>"
      assert html_report =~ "<body class=\"A5\">"
    end

    test "A5 landscape" do
      html_report =
        Rapport.new(@empty_template, :A5, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A5 landscape}</style>"
      assert html_report =~ "<body class=\"A5 landscape\">"
    end

    test "half_letter portrait" do
      html_report =
        Rapport.new(@empty_template, :half_letter, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: half_letter}</style>"
      assert html_report =~ "<body class=\"half_letter\">"
    end

    test "half_letter landscape" do
      html_report =
        Rapport.new(@empty_template, :half_letter, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: half_letter landscape}</style>"
      assert html_report =~ "<body class=\"half_letter landscape\">"
    end

    test "letter portrait" do
      html_report =
        Rapport.new(@empty_template, :letter, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: letter}</style>"
      assert html_report =~ "<body class=\"letter\">"
    end

    test "letter landscape" do
      html_report =
        Rapport.new(@empty_template, :letter, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: letter landscape}</style>"
      assert html_report =~ "<body class=\"letter landscape\">"
    end

    test "legal portrait" do
      html_report =
        Rapport.new(@empty_template, :legal, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: legal}</style>"
      assert html_report =~ "<body class=\"legal\">"
    end

    test "legal landscape" do
      html_report =
        Rapport.new(@empty_template, :legal, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: legal landscape}</style>"
      assert html_report =~ "<body class=\"legal landscape\">"
    end

    test "junior legal portrait" do
      html_report =
        Rapport.new(@empty_template, :junior_legal, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: junior_legal}</style>"
      assert html_report =~ "<body class=\"junior_legal\">"
    end

    test "junior legal landscape" do
      html_report =
        Rapport.new(@empty_template, :junior_legal, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: junior_legal landscape}</style>"
      assert html_report =~ "<body class=\"junior_legal landscape\">"
    end

    test "ledger portrait" do
      html_report =
        Rapport.new(@empty_template, :ledger, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: ledger}</style>"
      assert html_report =~ "<body class=\"ledger\">"
    end

    test "ledger landscape" do
      html_report =
        Rapport.new(@empty_template, :ledger, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: ledger landscape}</style>"
      assert html_report =~ "<body class=\"ledger landscape\">"
    end
  end

  describe "add_page" do
    test "add one page" do
      report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Hello world"})

      assert length(report.pages) == 1
    end

    test "add two pages" do
      report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "One"})
        |> Rapport.add_page(@hello_template, %{hello: "Two"})

      assert length(report.pages) == 2
    end
  end

  ### set_field
  describe "set_field/2" do
    test "set_field" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Hello World!"})
        |> Rapport.generate_html

      assert html_report =~ "Hello World!"
    end

    test "set_field two times" do
      fields = %{first: "first!", second: "second!"}
      html_report =
        Rapport.new
        |> Rapport.add_page(@two_fields_template, fields)
        |> Rapport.generate_html

      assert html_report =~ "first!"
      assert html_report =~ "second!"
    end

    test "set_field with a list" do
      list = ["one", "two", "three"]

      html_report =
        Rapport.new
        |> Rapport.add_page(@list_template, %{list: list})
        |> Rapport.generate_html

      assert html_report =~ "one"
      assert html_report =~ "two"
      assert html_report =~ "three"
    end

    test "set_field with a list of maps" do
      people = [
        %{firstname: "Richard", lastname: "Nyström", age: 33},
        %{firstname: "Kristin", lastname: "Nyvall", age: 34},
        %{firstname: "Nils", lastname: "Nyvall", age: 3}
      ]
      fields = %{people: people}
      html_report =
        Rapport.new
        |> Rapport.add_page(@list_map_template, fields)
        |> Rapport.generate_html

      assert html_report =~ "Richard"
      assert html_report =~ "Nyvall"
      assert html_report =~ "33"
    end
  end

  describe "generate_html" do
    test "make sure normalize & paper css is included" do
      html_report =
        Rapport.new(@empty_template)
        |> Rapport.generate_html
      assert html_report =~ "normalize.css v7.0.0"
      assert html_report =~ "paper.css"
    end
  end
end
