defmodule AshMysql.Test.PostLink do
  @moduledoc false
  use Ash.Resource,
    domain: AshMysql.Test.Domain,
    data_layer: AshMysql.DataLayer

  mysql do
    table "post_links"
    repo AshMysql.TestRepo
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :update, :destroy])
  end

  identities do
    identity(:unique_link, [:source_post_id, :destination_post_id])
  end

  attributes do
    attribute :state, :atom do
      public?(true)
      constraints(one_of: [:active, :archived])
      default(:active)
    end
  end

  relationships do
    belongs_to :source_post, AshMysql.Test.Post do
      public?(true)
      allow_nil?(false)
      primary_key?(true)
    end

    belongs_to :destination_post, AshMysql.Test.Post do
      public?(true)
      allow_nil?(false)
      primary_key?(true)
    end
  end
end
