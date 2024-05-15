defmodule AshMysql.ManualRelationship do
  @moduledoc "A behavior for mysql-specific manual relationship functionality"

  @callback ash_mysql_join(
              source_query :: Ecto.Query.t(),
              opts :: Keyword.t(),
              current_binding :: term,
              destination_binding :: term,
              type :: :inner | :left,
              destination_query :: Ecto.Query.t()
            ) :: {:ok, Ecto.Query.t()} | {:error, term}

  @callback ash_mysql_subquery(
              opts :: Keyword.t(),
              current_binding :: term,
              destination_binding :: term,
              destination_query :: Ecto.Query.t()
            ) :: {:ok, Ecto.Query.t()} | {:error, term}

  defmacro __using__(_) do
    quote do
      @behaviour AshMysql.ManualRelationship
    end
  end
end
