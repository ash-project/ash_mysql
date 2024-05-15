defmodule AshMysql.SelectTest do
  @moduledoc false
  use AshMysql.RepoCase, async: false
  alias AshMysql.Test.Post

  require Ash.Query

  test "values not selected in the query are not present in the response" do
    Post
    |> Ash.Changeset.for_create(:create, %{title: "title"})
    |> Ash.create!()

    assert [%{title: %Ash.NotLoaded{}}] = Ash.read!(Ash.Query.select(Post, :id))
  end
end
