# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.Account do
  @moduledoc false
  use Ash.Resource, domain: AshMysql.Test.Domain, data_layer: AshMysql.DataLayer

  actions do
    default_accept(:*)
    defaults([:create, :read, :update, :destroy])
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:is_active, :boolean, public?: true)
  end

  calculations do
    calculate(
      :active,
      :boolean,
      expr(is_active),
      public?: true
    )
  end

  mysql do
    table "accounts"
    repo(AshMysql.TestRepo)
  end

  relationships do
    belongs_to(:user, AshMysql.Test.User, public?: true)
  end
end
