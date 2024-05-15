defmodule AshMysql.EnumTest do
  @moduledoc false
  use AshMysql.RepoCase, async: false
  alias AshMysql.Test.Post

  require Ash.Query

  test "valid values are properly inserted" do
    Post
    |> Ash.Changeset.for_create(:create, %{title: "title", status: :open})
    |> Ash.create!()
  end
end
