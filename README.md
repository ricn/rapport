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
    {:rapport, "~> 0.4"}
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

[See example here](https://rawgit.com/ricn/rapport/master/examples/hello.html)

## More examples
  * [Custom fonts and styling](https://rawgit.com/ricn/rapport/master/examples/custom_fonts_and_styles.html)
  * [Invoice example](https://rawgit.com/ricn/rapport/master/examples/invoice.html)
  * [Page numbering](https://rawgit.com/ricn/rapport/master/examples/page_numbering.html)
  * [List of people with cover page](https://rawgit.com/ricn/rapport/master/examples/list_of_people.html)
  * More examples are coming...

If you want to see how the examples has been created, you can look at the `example_test.exs` file in the test folder.

## Credits

The following people have contributed ideas, documentation, or code to Librex:

* Richard Nyström

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
