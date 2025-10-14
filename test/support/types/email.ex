# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule Test.Support.Types.Email do
  @moduledoc false
  use Ash.Type.NewType,
    subtype_of: :string
end
