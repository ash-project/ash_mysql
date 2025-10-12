# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
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
