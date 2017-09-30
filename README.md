# Rapport

Rapport aims to provide a robust set of modules to generate HTML reports that both looks good in the browser and when being printed.

[![Build Status](https://travis-ci.org/ricn/rapport.png?branch=master)](https://travis-ci.org/ricn/rapport)
[![Hex.pm](https://img.shields.io/hexpm/v/rapport.svg)](https://hex.pm/packages/rapport)
[![Inline docs](http://inch-ci.org/github/ricn/rapport.svg?branch=master)](http://inch-ci.org/github/ricn/rapport)
[![Coverage Status](https://coveralls.io/repos/github/ricn/rapport/badge.svg?branch=master)](https://coveralls.io/github/ricn/rapport?branch=master)

## Installation

The package can be installed
by adding `rapport` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rapport, "~> 0.4.0"}
  ]
end
```

## Hello world

```elixir
page_template = "<h1><%= @hello %></h1>"
html_report =
  Rapport.new
  |> Rapport.add_page(page_template, %{hello: "Hello world!"})
  |> Rapport.generate_html
```

The snippet above generates a report containing only one page with a heading that says "Hello world!".

[See example here](https://cdn.rawgit.com/ricn/rapport/master/examples/hello.html)

## Add styling and custom fonts to a report

```elixir
report_template = """
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Tangerine">
<style>
  h1 {
    font-family: 'Tangerine', serif;
    font-size: 48px;
    text-shadow: 4px 4px 4px #aaa;
    margin: 0;
  }
</style>
"""
page_template = "<h1><%= @hello %></h1>"
html_report =
  Rapport.new(report_template)
  |> Rapport.add_page(page_template, %{hello: "Hello world!"})
  |> Rapport.generate_html
```

The report template is injected in the HTML head section so you can bring in things like styles, fonts and JavaScript.

[See example here](https://cdn.rawgit.com/ricn/rapport/master/examples/custom_fonts_and_styles.html)

## More advanced examples
  * [Invoice example] (https://cdn.rawgit.com/ricn/rapport/master/examples/invoice.html)
  * [List of people with cover page] (https://cdn.rawgit.com/ricn/rapport/master/examples/list_of_people.html)
  * More examples are coming...

The examples are generated from `example_test.exs` in the test folder if you want to see how they are created.

## Credits

The following people have contributed ideas, documentation, or code to Librex:

* Richard Nyström

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
