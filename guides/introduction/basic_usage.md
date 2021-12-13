# Basic usage

## Hello world

```elixir
page_template = "<h1><%= @hello %></h1>"

Rapport.new
  |> Rapport.add_page(page_template, %{hello: "Hello world!"})
  |> Rapport.save_to_file("/your/path/hello.html")
```

First we need to define a page template called `page_template` which is just a simple [EEx](https://hexdocs.pm/eex/EEx.html) template which allows you to embed Elixir code inside a string in a robust way.

Next we call `Rapport.new` which will setup a basic report with sane defaults.

In order to add a page to the report we just need to call `Rapport.add_page` and pass in the page template and a map with the data we want to send in to the template.

`Rapport.save_to_file` is just a helper function to save a report to disk.

