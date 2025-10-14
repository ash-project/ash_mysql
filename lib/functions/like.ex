# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Functions.Like do
  @moduledoc """
  Maps to the builtin mysql function `like`.
  """

  use Ash.Query.Function, name: :like

  def args, do: [[:string, :string]]
end
