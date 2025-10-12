# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.Profile do
  @moduledoc false
  use Ash.Resource,
    domain: AshMysql.Test.Domain,
    data_layer: AshMysql.DataLayer

  mysql do
    table("profile")
    repo(AshMysql.TestRepo)
  end

  attributes do
    uuid_primary_key(:id, writable?: true)
    attribute(:description, :string, public?: true)
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :update, :destroy])
  end

  relationships do
    belongs_to(:author, AshMysql.Test.Author, public?: true)
  end
end
