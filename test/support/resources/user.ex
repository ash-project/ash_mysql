defmodule AshMysql.Test.User do
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

  mysql do
    table "users"
    repo(AshMysql.TestRepo)
  end

  relationships do
    belongs_to(:organization, AshMysql.Test.Organization, public?: true)
    has_many(:accounts, AshMysql.Test.Account, public?: true)
  end
end
