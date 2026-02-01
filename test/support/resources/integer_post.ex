# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.IntegerPost do
  @moduledoc false
  use Ash.Resource,
    domain: AshMysql.Test.Domain,
    data_layer: AshMysql.DataLayer

  mysql do
    table "integer_posts"
    repo AshMysql.TestRepo
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :update, :destroy])
  end

  attributes do
    integer_primary_key(:id)
    attribute(:title, :string, public?: true)
  end
end
