# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.Types.Status do
  @moduledoc false
  use Ash.Type.Enum, values: [:open, :closed]

  def storage_type, do: :string
end
