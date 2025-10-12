# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
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
