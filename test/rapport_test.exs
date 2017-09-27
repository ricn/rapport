defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")
  @two_fields_template Path.join(__DIR__, "templates/two_fields.html.eex")
  @list_template Path.join(__DIR__, "templates/list.html.eex")
  @list_map_template Path.join(__DIR__, "templates/list_map.html.eex")
  @empty_template Path.join(__DIR__, "templates/empty.html.eex")

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

    test "must set title" do
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

    test "all allowed paper sizes" do
      all = [:A4, :A3, :A5, :half_letter, :letter, :legal, :junior_legal, :ledger]
      Enum.each(all, fn(paper_size) ->
        assert Rapport.new("Title", paper_size, :portrait).paper_size == paper_size
      end)
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
        Rapport.new("Report", :A5, :portrait)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A5}</style>"
      assert html_report =~ "<body class=\"A5\">"
    end

    test "must set rotation correctly" do
      html_report =
        Rapport.new("Report", :A5, :landscape)
        |> Rapport.generate_html

      assert html_report =~ "<style>@page {size: A5 landscape}</style>"
      assert html_report =~ "<body class=\"A5 landscape\">"
    end

    test "set_field" do
      html_report =
        Rapport.new
        |> Rapport.add_page(@hello_template, %{hello: "Hello World!"})
        |> Rapport.generate_html

      assert html_report =~ "<article>Hello World!</article>"
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
end
