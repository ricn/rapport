defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")
  @two_fields_template Path.join(__DIR__, "templates/two_fields.html.eex")
  @list_template Path.join(__DIR__, "templates/list.html.eex")
  @list_map_template Path.join(__DIR__, "templates/list_map.html.eex")

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
end
