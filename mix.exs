defmodule JsonJanitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :json_janitor,
      version: "1.0.0",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      name: "JsonJanitor",
      source_url: "https://github.com/mbramson/json_janitor",
      package: package(),
      docs: docs(),
      deps: deps()
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
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.20", only: :dev},
      {:jason, "~> 1.0", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:stream_data, "~> 0.4", only: :test},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    """
    `JsonJanitor` sanitizes elixir terms so that they can be serialized to
    JSON.
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Mathew Bramson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mbramson/json_janitor"}
    ]
  end
  defp docs() do
    [
      main: "JsonJanitor",
      source_url: "https://github.com/mbramson/json_janitor",
    ]
  end
end
