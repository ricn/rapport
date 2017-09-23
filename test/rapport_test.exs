defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")
  @two_fields_template Path.join(__DIR__, "templates/two_fields.html.eex")
  @list_template Path.join(__DIR__, "templates/list.html.eex")
  @list_map_template Path.join(__DIR__, "templates/list_map.html.eex")

  test "hello world" do
    html_report =
      Rapport.new(@hello_template)
      |> Rapport.set_field(:hello, "Hello World!")
      |> Rapport.generate_html

    assert html_report =~ "Hello World!"
    assert html_report =~ "@page { size: A4 }"
    assert html_report =~ "body class=\"A4\""
  end

  test "set two fields" do
    html_report =
      Rapport.new(@two_fields_template, :A4)
      |> Rapport.set_field(:first, "first!")
      |> Rapport.set_field(:second, "second!")
      |> Rapport.generate_html

    assert html_report =~ "first!"
    assert html_report =~ "second!"
  end

  test "set a field with list" do
    html_report =
      Rapport.new(@list_template, :A4)
      |> Rapport.set_field(:list, ["one", "two", "three"])
      |> Rapport.generate_html

    assert html_report =~ "one"
    assert html_report =~ "two"
    assert html_report =~ "three"
  end

  test "field with a list of maps" do
    people = [
      %{firstname: "Richard", lastname: "Nyström", age: 33},
      %{firstname: "Kristin", lastname: "Nyvall", age: 34},
      %{firstname: "Nils", lastname: "Nyvall", age: 3}
    ]
    html_report =
      Rapport.new(@list_map_template, :A4)
      |> Rapport.set_field(:people, people)
      |> Rapport.generate_html

    assert html_report =~ "Richard"
    assert html_report =~ "Nyvall"
    assert html_report =~ "33"
  end
end
