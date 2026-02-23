# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Transformers.ValidateReferences do
  @moduledoc false
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def after_compile?, do: true

  def transform(dsl) do
    dsl
    |> AshMysql.DataLayer.Info.references()
    |> Enum.each(fn reference ->
      unless Ash.Resource.Info.relationship(dsl, reference.relationship) do
        raise Spark.Error.DslError,
          path: [:mysql, :references, reference.relationship],
          module: Transformer.get_persisted(dsl, :module),
          message:
            "Found reference configuration for relationship `#{reference.relationship}`, but no such relationship exists"
      end
    end)

    {:ok, dsl}
  end
end
