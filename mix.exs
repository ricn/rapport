defmodule Rapport.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rapport,
      version: "0.7.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: desc(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp docs do
    [extras: ["README.md"], main: "readme"]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "0.14.4", only: [:dev, :test]},
      {:ex_doc, "0.28.4", only: :dev},
      {:inch_ex, "2.0.0", only: :docs},
      {:faker, "0.17.0", only: :test},
      {:doctor, "0.18.0", only: :dev},
      {:dialyxir, "1.1.0", only: [:dev], runtime: false},
      {:credo, "1.6.4", only: [:dev, :test], runtime: false},
      {:barlix, "0.6.1"},
      {:uuid, "1.1.8"}
    ]
  end

  defp desc do
    """
    Rapport aims to provide a robust set of modules to generate
    HTML reports that both looks good in the browser and when being printed.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Richard Nyström"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/ricn/rapport",
        "Docs" => "http://hexdocs.pm/rapport"
      }
    ]
  end
end
