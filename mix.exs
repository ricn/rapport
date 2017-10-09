defmodule Rapport.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rapport,
      version: "0.6.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: desc(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:excoveralls, "~> 0.7", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, "0.5.6", only: :docs},
      {:faker, "0.9.0", only: :test}
    ]
  end

  defp desc do
    """
    Rapport aims to provide a robust set of modules to generate
    HTML reports that both looks good in the browser and when being printed.
    """
  end

  defp package do
      [files: ["lib", "mix.exs", "README*", "LICENSE*"],
       maintainers: ["Richard Nyström"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/ricn/rapport", "Docs" => "http://hexdocs.pm/rapport"}]
  end
end
