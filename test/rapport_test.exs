defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")
  @two_fields_template Path.join(__DIR__, "templates/two_fields.html.eex")
  @list_template Path.join(__DIR__, "templates/list.html.eex")
  @list_map_template Path.join(__DIR__, "templates/list_map.html.eex")

  describe "new" do

    test "must set sane defaults" do
      report = Rapport.new
      assert is_map(report)
      assert Map.has_key?(report, :title)
      assert Map.get(report, :title) == "Report"
      assert Map.has_key?(report, :paper_size)
      assert Map.has_key?(report, :rotation)
      assert Map.has_key?(report, :pages)
      assert is_list(Map.get(report, :pages))
    end

    test "must allow report template" do
      style = """
      <style>
        h1 {
          color: red;
        }
      </style>
      """
      page_template = """
      <section class="sheet padding-10mm">
        <h1><%= @hello %></h1>
      </section>
      """
      html_report =
        Rapport.new(style)
        |> Rapport.add_page(page_template, %{hello: "Hello!"})
        |> Rapport.generate_html

      assert html_report =~ "color: red;"
    end

    # Move this to add_page
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
  end

  describe "add_page" do
    test "add one page" do
      report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Hello world"})

      assert length(report.pages) == 1
      assert List.first(report.pages).fields.hello == "Hello world"
    end

    test "add two pages" do
      report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "One"})
        |> Rapport.add_page(@hello_template, %{hello: "Two"})

      assert length(report.pages) == 2
    end
  end

  describe "generate_html" do
    test "must include normalize & paper css" do
      html_report =
        Rapport.new
        |> Rapport.generate_html
      assert html_report =~ "normalize.css v7.0.0"
      assert html_report =~ "paper.css"
    end

    test "must set paper size correctly" do
      html_report =
        Rapport.new
        |> Rapport.set_paper_size(:A5)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A5}</style>"
      assert html_report =~ "<body class=\"A5\">"
    end

    test "must set rotation correctly" do
      html_report =
        Rapport.new
        |> Rapport.set_rotation(:landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A4 landscape}</style>"
      assert html_report =~ "<body class=\"A4 landscape\">"
    end

    test "must generate correct html with one field" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Hello World!"})
        |> Rapport.generate_html

      assert html_report =~ "<article>Hello World!</article>"
    end

    test "must generate correct html with several fields" do
      fields = %{first: "first!", second: "second!"}
      html_report =
        Rapport.new
        |> Rapport.add_page(@two_fields_template, fields)
        |> Rapport.generate_html

      assert html_report =~ "first!"
      assert html_report =~ "second!"
    end

    test "must generate html with lists" do
      list = ["one", "two", "three"]

      html_report =
        Rapport.new
        |> Rapport.add_page(@list_template, %{list: list})
        |> Rapport.generate_html

      assert html_report =~ "one"
      assert html_report =~ "two"
      assert html_report =~ "three"
    end

    test "must generate html with maps" do
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

  describe "set_title" do
    test "must set the title for the report" do
      html_report =
        Rapport.new
        |> Rapport.set_title("My new title")
        |> Rapport.generate_html

      assert html_report =~ "<title>My new title</title>"
    end
  end

  describe "set_paper_size" do
    test "must set paper size for the report" do
      html_report =
        Rapport.new
        |> Rapport.set_paper_size(:A5)
        |> Rapport.generate_html

        assert html_report =~ "<style>@page {size: A5}</style>"
        assert html_report =~ "<body class=\"A5\">"
    end

    test "must raise argument error when paper size is invalid" do
      assert_raise ArgumentError, ~r/^Invalid paper size/, fn ->
        Rapport.new
        |> Rapport.set_paper_size(:WRONG)
      end
    end

    test "all allowed paper sizes" do
      all = [:A4, :A3, :A5, :half_letter, :letter, :legal, :junior_legal, :ledger]
      report = Rapport.new
      Enum.each(all, fn(paper_size) ->
        assert Rapport.set_paper_size(report, paper_size).paper_size == paper_size
      end)
    end
  end

  describe "set_rotation" do
    test "must rotation for the report" do
      html_report =
        Rapport.new
        |> Rapport.set_rotation(:landscape)
        |> Rapport.generate_html

        assert html_report =~ "<style>@page {size: A4 landscape}</style>"
        assert html_report =~ "<body class=\"A4 landscape\">"
    end

    test "must raise argument error when rotation is invalid" do
      assert_raise ArgumentError, ~r/^Invalid rotation/, fn ->
        Rapport.new
        |> Rapport.set_rotation(:nope)
      end
    end

    test "all allowed rotations" do
      all = [:portrait, :landscape]
      report = Rapport.new
      Enum.each(all, fn(rotation) ->
        assert Rapport.set_rotation(report, rotation).rotation == rotation
      end)
    end
  end

  describe "set_padding" do
    test "must set padding on all pages" do
      html_report =
        Rapport.new
        |> Rapport.set_padding(20)
        |> Rapport.add_page(@hello_template, %{hello: "hello"})
        |> Rapport.generate_html

        assert html_report =~ "<div class=\"sheet padding-20mm\">"
    end

    test "all allowed paddings" do
      all = [10, 15, 20, 25]
      report = Rapport.new
      Enum.each(all, fn(padding) ->
        assert Rapport.set_padding(report, padding).padding == padding
      end)
    end

    test "must raise argument error when padding is invalid" do
      assert_raise ArgumentError, ~r/^Invalid padding/, fn ->
        Rapport.new
        |> Rapport.set_padding(5)
      end
    end
  end

  # Tests that are used to generate examples files
  describe "examples" do
    test "hello.html" do
      page_template = "<h1><%= @hello %></h1>"
      html_report =
        Rapport.new
        |> Rapport.add_page(page_template, %{hello: "Hello world!"})
        |> Rapport.generate_html

      file = Path.join([System.cwd, "examples", "hello.html"])
      File.write!(file, html_report)
    end

    test "custom fonts and styles" do
      report_template = """
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Tangerine">
      <style>
        h1 {
          font-family: 'Tangerine', serif;
          font-size: 48px;
          text-shadow: 4px 4px 4px #aaa;
        }
      </style>
      """
      page_template = "<h1><%= @hello %></h1>"
      html_report =
        Rapport.new(report_template)
        |> Rapport.add_page(page_template, %{hello: "Hello world!"})
        |> Rapport.generate_html

      file = Path.join([System.cwd, "examples", "custom_fonts_and_styles.html"])
      File.write!(file, html_report)
    end
  end
end
