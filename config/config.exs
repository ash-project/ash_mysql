# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

import Config

if Mix.env() == :dev do
  config :git_ops,
    mix_project: AshMysql.MixProject,
    changelog_file: "CHANGELOG.md",
    repository_url: "https://github.com/ash-project/ash_mysql",
    # Instructs the tool to manage your mix version in your `mix.exs` file
    # See below for more information
    manage_mix_version?: true,
    # Instructs the tool to manage the version in your README.md
    # Pass in `true` to use `"README.md"` or a string to customize
    manage_readme_version: [
      "README.md",
      "documentation/tutorials/getting-started-with-ash-mysql.md"
    ],
    version_tag_prefix: "v"
end

if Mix.env() == :test do
  config :ash, :validate_domain_resource_inclusion?, false
  config :ash, :validate_domain_config_inclusion?, false

  config :ash_mysql, AshMysql.TestRepo,
    username: "root",
    database: "ash_mysql_test",
    hostname: "localhost",
    log_stacktrace_mfa: fn t, _, _ -> t end,
    pool: Ecto.Adapters.SQL.Sandbox,
    # sobelow_skip ["Config.Secrets"]
    password: "root",
    charset: "utf8mb4",
    collation: "utf8mb4_0900_as_cs"

  config :ash_mysql, AshMysql.TestRepo, migration_primary_key: [name: :id, type: :binary_id]

  config :ash_mysql, AshMysql.TestNoSandboxRepo,
    username: "root",
    database: "ash_mysql_test",
    hostname: "localhost"

  # sobelow_skip ["Config.Secrets"]
  config :ash_mysql, AshMysql.TestNoSandboxRepo, password: "root"

  config :ash_mysql, AshMysql.TestNoSandboxRepo,
    migration_primary_key: [name: :id, type: :binary_id]

  # ecto_repos: [AshMysql.TestRepo, AshMysql.TestNoSandboxRepo],
  config :ash_mysql,
    ecto_repos: [AshMysql.TestRepo],
    ash_domains: [
      AshMysql.Test.Domain
    ]

  config :logger, level: :warning
end
