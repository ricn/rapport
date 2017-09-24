defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")
  @two_fields_template Path.join(__DIR__, "templates/two_fields.html.eex")
  @list_template Path.join(__DIR__, "templates/list.html.eex")
  @list_map_template Path.join(__DIR__, "templates/list_map.html.eex")
  @empty_template Path.join(__DIR__, "templates/empty.html.eex")

  ### set_field
  test "set_field" do
    html_report =
      Rapport.new(@hello_template)
      |> Rapport.set_field(:hello, "Hello World!")
      |> Rapport.generate_html

    assert html_report =~ "Hello World!"
  end

  test "set_field two times" do
    html_report =
      Rapport.new(@two_fields_template)
      |> Rapport.set_field(:first, "first!")
      |> Rapport.set_field(:second, "second!")
      |> Rapport.generate_html

    assert html_report =~ "first!"
    assert html_report =~ "second!"
  end

  test "set_field with a list" do
    html_report =
      Rapport.new(@list_template)
      |> Rapport.set_field(:list, ["one", "two", "three"])
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
    html_report =
      Rapport.new(@list_map_template)
      |> Rapport.set_field(:people, people)
      |> Rapport.generate_html

    assert html_report =~ "Richard"
    assert html_report =~ "Nyvall"
    assert html_report =~ "33"
  end

  test "set_field using a string key" do
    html_report =
      Rapport.new(@hello_template)
      |> Rapport.set_field("hello", "Hello World!")
      |> Rapport.generate_html

    assert html_report =~ "Hello World!"
  end

  ### set_title
  test "set_title" do
    html_report =
      Rapport.new(@hello_template)
      |> Rapport.set_title("My title")
      |> Rapport.set_field("hello", "Hello World!")
      |> Rapport.generate_html

    assert html_report =~ "<title>My title</title>"
  end

  test "title must be a binary" do
    assert_raise FunctionClauseError, ~r/^no function clause matching in Rapport.set_title/, fn ->
      Rapport.new(@hello_template)
        |> Rapport.set_title([])
    end
  end

  ### Paper sizes & rotation
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

  ### CSS
  test "make sure normalize & paper css is included" do
    html_report =
      Rapport.new(@empty_template)
      |> Rapport.generate_html
    assert html_report =~ "normalize.css v7.0.0"
    assert html_report =~ "paper.css"
  end

  ### new

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
      Rapport.new(inline_template)
      |> Rapport.set_field(:hello, "Inline template")
      |> Rapport.generate_html

    assert html_report =~ "Inline template"
  end

  ### set

end
