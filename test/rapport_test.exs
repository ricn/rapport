defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")
  @two_fields_template Path.join(__DIR__, "templates/two_fields.html.eex")

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
end
