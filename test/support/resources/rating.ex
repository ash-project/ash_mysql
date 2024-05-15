defmodule AshMysql.Test.Rating do
  @moduledoc false
  use Ash.Resource,
    domain: AshMysql.Test.Domain,
    data_layer: AshMysql.DataLayer

  mysql do
    polymorphic?(true)
    repo AshMysql.TestRepo
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :update, :destroy])
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:score, :integer, public?: true)
    attribute(:resource_id, :uuid, public?: true)
  end
end
