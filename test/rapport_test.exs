defmodule RapportTest do
  use ExUnit.Case
  doctest Rapport

  @hello_template Path.join(__DIR__, "templates/hello.html.eex")

  test "hello world A4" do
    # Use a template (eex) - binary or path
    # Input fields -
    # Generate PDF -
    # Preview in browser
    html_report =
      Rapport.new(@hello_template, :A4)
      |> Rapport.set_field(:hello, "Hello World!")
      |> Rapport.generate_html

    IO.inspect html_report
    File.write("test.html", html_report)  
    assert html_report != nil
  end
end
