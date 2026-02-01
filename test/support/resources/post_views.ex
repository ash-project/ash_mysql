# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.PostView do
  @moduledoc false
  use Ash.Resource, domain: AshMysql.Test.Domain, data_layer: AshMysql.DataLayer

  actions do
    default_accept(:*)
    defaults([:create, :read])
  end

  attributes do
    create_timestamp(:time)
    attribute(:browser, :atom, constraints: [one_of: [:firefox, :chrome, :edge]], public?: true)
  end

  relationships do
    belongs_to :post, AshMysql.Test.Post do
      public?(true)
      allow_nil?(false)
      attribute_writable?(true)
    end
  end

  resource do
    require_primary_key?(false)
  end

  mysql do
    table "post_views"
    repo AshMysql.TestRepo

    references do
      reference :post, ignore?: true
    end
  end
end
