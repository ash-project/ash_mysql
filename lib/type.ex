# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Type do
  @moduledoc """
  MySQL specific callbacks for `Ash.Type`.

  Use this in addition to `Ash.Type`.
  """

  @callback value_to_mysql_default(Ash.Type.t(), Ash.Type.constraints(), term) ::
              {:ok, String.t()} | :error

  defmacro __using__(_) do
    quote do
      @behaviour AshMysql.Type
      def value_to_mysql_default(_, _, _), do: :error

      defoverridable value_to_mysql_default: 3
    end
  end
end
