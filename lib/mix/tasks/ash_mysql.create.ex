# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Mix.Tasks.AshMysql.Create do
  use Mix.Task

  @shortdoc "Creates the repository storage"

  @switches [
    quiet: :boolean,
    domains: :string,
    no_compile: :boolean,
    no_deps_check: :boolean
  ]

  @aliases [
    q: :quiet
  ]

  @moduledoc """
  Create the storage for repos in all resources for the given (or configured) domains.

  ## Examples

      mix ash_mysql.create
      mix ash_mysql.create --domains MyApp.Domain1,MyApp.Domain2

  ## Command line options

    * `--domains` - the domains who's repos you want to migrate.
    * `--quiet` - do not log output
    * `--no-compile` - do not compile before creating
    * `--no-deps-check` - do not compile before creating
  """

  @doc false
  def run(args) do
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)

    repos = AshMysql.Mix.Helpers.repos!(opts, args)

    repo_args =
      Enum.flat_map(repos, fn repo ->
        ["-r", to_string(repo)]
      end)

    rest_opts = AshMysql.Mix.Helpers.delete_arg(args, "--domains")

    Mix.Task.reenable("ecto.create")

    Mix.Task.run("ecto.create", repo_args ++ rest_opts)
  end
end
