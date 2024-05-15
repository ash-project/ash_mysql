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
