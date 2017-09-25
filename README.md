# Rapport

Reporting solution for Elixir using EEx templates, HTML and CSS built to support printing.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rapport` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rapport, "~> 0.4.0"}
  ]
end
```

## Basic Usage

```elixir
template = """
<section class="sheet padding-10mm">
  <article><%= @hello %></article>
</section>
"""
html_report =
  Rapport.new(template)
  |> Rapport.set_field(:hello, "Inline template")
  |> Rapport.generate_html
```
