# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Transformers.EnsureTableOrPolymorphic do
  @moduledoc false
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def transform(dsl) do
    if Transformer.get_option(dsl, [:mysql], :polymorphic?) ||
         Transformer.get_option(dsl, [:mysql], :table) do
      {:ok, dsl}
    else
      resource = Transformer.get_persisted(dsl, :module)

      raise Spark.Error.DslError,
        module: resource,
        message: """
        Must configure a table for #{inspect(resource)}.

        For example:

        ```elixir
        mysql do
          table "the_table"
          repo YourApp.Repo
        end
        ```
        """,
        path: [:mysql, :table]
    end
  end
end
