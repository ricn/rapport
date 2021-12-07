<p align="center"><img src="test/images/logo/horizontal.png" alt="rapport" height="110px"></p>

Rapport aims to provide a robust set of modules to generate HTML reports that both looks good in the browser and when being printed.

[![Elixir CI](https://github.com/ricn/rapport/actions/workflows/elixir.yml/badge.svg)](https://github.com/ricn/rapport/actions/workflows/elixir.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/rapport.svg)](https://hex.pm/packages/rapport)
[![Coverage Status](https://coveralls.io/repos/github/ricn/rapport/badge.svg?branch=master)](https://coveralls.io/github/ricn/rapport?branch=master)

## Installation

The package can be installed
by adding `rapport` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rapport, "~> 0.6"}
  ]
end
```

## Notable features
  * Specify paper size for the report
  * Specify rotation for the report
  * Image helpers
  * Font helpers
  * Page numbering
  * Add custom styling & even Javascript
  * Barcodes

## Hello world

```elixir
page_template = "<h1><%= @hello %></h1>"
html_report =
  Rapport.new
  |> Rapport.add_page(page_template, %{hello: "Hello world!"})
  |> Rapport.save_to_file("/home/users/ricn/hello.html")
```

The snippet above generates a report containing only one page with a heading that says "Hello world!".

[See example here](https://rawgit.com/ricn/rapport/master/examples/hello.html)

## More examples
  * [Custom fonts and styling](https://rawgit.com/ricn/rapport/master/examples/custom_fonts_and_styles.html)
  * [Invoice](https://rawgit.com/ricn/rapport/master/examples/invoice.html)
  * [Page numbering](https://rawgit.com/ricn/rapport/master/examples/page_numbering.html)
  * [List of people with cover page](https://rawgit.com/ricn/rapport/master/examples/list_of_people.html)
  * [Barcodes](https://rawgit.com/ricn/rapport/master/examples/barcodes.html)
  * More examples are coming...

If you want to see how the examples has been created, you can look at the `example_test.exs` file in the test folder.

## Phoenix integration

It's easy to Integrate Rapport with Phoenix. Just load the template as a module attribute, create the HTML for the report
and send a response with the generated HTML:

```elixir
defmodule ReportsWeb.ReportController do
  use ReportsWeb, :controller

  @page_template File.read!(Path.join(__DIR__, "../templates/report/hello.html.eex"))

  def hello(conn, _params) do
    html_report =
       Rapport.new
       |> Rapport.add_page(@page_template, %{hello: "Hello World!"})
       |> Rapport.generate_html

       conn
       |> put_resp_content_type("text/html")
       |> send_resp(200, html_report)
  end
end
```

## Upcoming features
  * Charts
  * PDF conversion

## Credits

The following people have contributed ideas, documentation, or code to Rapport:

* Richard Nyström

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
