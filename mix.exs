# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.MixProject do
  use Mix.Project

  @description """
  The MySQL data layer for Ash Framework.
  """

  @version "0.1.0-dev"

  def project do
    [
      app: :ash_mysql,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.github": :test,
        "test.create": :test,
        "test.migrate": :test,
        "test.rollback": :test,
        "test.check_migrations": :test,
        "test.drop": :test,
        "test.generate_migrations": :test,
        "test.reset": :test
      ],
      dialyzer: [
        plt_add_apps: [:ecto, :ash, :mix]
      ],
      docs: &docs/0,
      aliases: aliases(),
      package: package(),
      source_url: "https://github.com/ash-project/ash_mysql",
      homepage_url: "https://github.com/ash-project/ash_mysql",
      consolidate_protocols: Mix.env() != :test
    ]
  end

  if Mix.env() == :test do
    def application do
      [
        mod: {AshMysql.TestApp, []}
      ]
    end
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: [
        "Zach Daniel <zach@zachdaniel.dev>",
        "Joel Kociolek <joel@annatel.net>"
      ],
      licenses: ["MIT"],
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*
      CHANGELOG* documentation),
      links: %{
        "GitHub" => "https://github.com/ash-project/ash_mysql",
        "Changelog" => "https://github.com/ash-project/ash_mysql/blob/main/CHANGELOG.md",
        "Discord" => "https://discord.gg/HTHRaaVPUc",
        "Website" => "https://ash-hq.org",
        "Forum" => "https://elixirforum.com/c/elixir-framework-forums/ash-framework-forum",
        "REUSE Compliance" => "https://api.reuse.software/info/github.com/ash-project/ash_mysql"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      logo: "logos/small-logo.png",
      extras: [
        {"README.md", title: "Home"},
        "documentation/tutorials/getting-started-with-ash-mysql.md",
        "documentation/topics/about-ash-mysql/what-is-ash-mysql.md",
        "documentation/topics/resources/references.md",
        "documentation/topics/resources/polymorphic-resources.md",
        "documentation/topics/development/migrations-and-tasks.md",
        "documentation/topics/development/testing.md",
        "documentation/topics/advanced/expressions.md",
        "documentation/topics/advanced/manual-relationships.md",
        "documentation/dsls/DSL-AshMysql.DataLayer.md",
        {"documentation/dsls/DSL-AshMysql.DataLayer.md",
         search_data: Spark.Docs.search_data_for(AshMysql.DataLayer)},
        "CHANGELOG.md"
      ],
      groups_for_extras: [
        Tutorials: [
          ~r'documentation/tutorials'
        ],
        "How To": ~r'documentation/how_to',
        Topics: ~r'documentation/topics',
        DSLs: ~r'documentation/dsls',
        "About AshMysql": [
          "CHANGELOG.md"
        ]
      ],
      groups_for_modules: [
        AshMysql: [
          AshMysql,
          AshMysql.Repo,
          AshMysql.DataLayer
        ],
        Utilities: [
          AshMysql.ManualRelationship
        ],
        Introspection: [
          AshMysql.DataLayer.Info,
          AshMysql.CustomExtension,
          AshMysql.CustomIndex,
          AshMysql.Reference,
          AshMysql.Statement
        ],
        Types: [
          AshMysql.Type
        ],
        Expressions: [
          AshMysql.Functions.Fragment,
          AshMysql.Functions.Like
        ],
        Internals: ~r/.*/
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.12"},
      {:myxql, ">= 0.0.0"},
      {:ecto, "~> 3.12"},
      {:jason, "~> 1.0"},
      {:ash, ash_version("~> 3.0")},
      {:picosat_elixir, "~> 0.2"},
      {:ash_sql, ash_sql_version("~> 0.2")},
      {:igniter, "~> 0.5", only: [:dev, :test]},
      {:git_ops, "~> 2.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.22", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.14", only: [:dev, :test]},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:sobelow, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:mix_audit, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp ash_version(default_version) do
    case System.get_env("ASH_VERSION") do
      nil ->
        default_version

      "local" ->
        [path: "../ash", override: true]

      "main" ->
        [git: "https://github.com/ash-project/ash.git"]

      version when is_binary(version) ->
        "~> #{version}"

      version ->
        version
    end
  end

  defp ash_sql_version(default_version) do
    case System.get_env("ASH_SQL_VERSION") do
      nil ->
        default_version

      "local" ->
        [path: "../ash_sql", override: true]

      "main" ->
        [git: "https://github.com/ash-project/ash_sql.git"]

      version when is_binary(version) ->
        "~> #{version}"

      version ->
        version
    end
  end

  defp aliases do
    [
      sobelow:
        "sobelow --skip -i Config.Secrets --ignore-files lib/migration_generator/migration_generator.ex",
      credo: "credo --strict",
      docs: [
        "spark.cheat_sheets",
        "docs",
        "spark.replace_doc_links"
      ],
      "spark.formatter": "spark.formatter --extensions AshMysql.DataLayer",
      "spark.cheat_sheets": "spark.cheat_sheets --extensions AshMysql.DataLayer",
      "spark.cheat_sheets_in_search":
        "spark.cheat_sheets_in_search --extensions AshMysql.DataLayer",
      "test.generate_migrations": "ash_mysql.generate_migrations",
      "test.check_migrations": "ash_mysql.generate_migrations --check",
      "test.migrate": "ash_mysql.migrate",
      "test.rollback": "ash_mysql.rollback",
      "test.create": "ash_mysql.create",
      "test.reset": ["test.drop", "test.create", "test.migrate"],
      "test.drop": "ash_mysql.drop"
    ]
  end
end
