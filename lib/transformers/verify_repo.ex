# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Transformers.VerifyRepo do
  @moduledoc false
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def after_compile?, do: true

  def transform(dsl) do
    repo = Transformer.get_option(dsl, [:mysql], :repo)

    cond do
      match?({:error, _}, Code.ensure_compiled(repo)) ->
        {:error, "Could not find repo module #{repo}"}

      repo.__adapter__() != Ecto.Adapters.MyXQL ->
        {:error, "Expected a repo using the MySQL adapter `Ecto.Adapters.MyXQL`"}

      true ->
        {:ok, dsl}
    end
  end
end
