# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.Types.StatusEnum do
  @moduledoc false
  use Ash.Type.Enum, values: [:open, :closed]

  # def storage_type, do: :status
end
