# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.Organization do
  @moduledoc false
  use Ash.Resource,
    domain: AshMysql.Test.Domain,
    data_layer: AshMysql.DataLayer

  mysql do
    table("orgs")
    repo(AshMysql.TestRepo)
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :update, :destroy])
  end

  attributes do
    uuid_primary_key(:id, writable?: true)
    attribute(:name, :string, public?: true)
  end
end
