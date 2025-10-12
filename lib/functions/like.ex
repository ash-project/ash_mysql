# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Functions.Like do
  @moduledoc """
  Maps to the builtin mysql function `like`.
  """

  use Ash.Query.Function, name: :like

  def args, do: [[:string, :string]]
end
