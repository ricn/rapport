defmodule Rapport.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rapport,
      version: "0.2.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: desc(),
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

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:excoveralls, "~> 0.7", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, only: :docs}
    ]
  end

  defp desc do
    "Reporting solution for Elixir"
  end

  defp package do
      [files: ["lib", "mix.exs", "README*", "LICENSE*"],
       maintainers: ["Richard Nyström"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/ricn/rapport", "Docs" => "http://hexdocs.pm/rapport"}]
  end
end
