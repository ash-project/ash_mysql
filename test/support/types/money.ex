# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.Money do
  @moduledoc false
  use Ash.Resource,
    data_layer: :embedded

  attributes do
    attribute :amount, :integer do
      public?(true)
      allow_nil?(false)
      constraints(min: 0)
    end

    attribute :currency, :atom do
      public?(true)
      constraints(one_of: [:eur, :usd])
    end
  end
end
