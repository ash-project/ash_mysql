# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.UniqueIdentityTest do
  use AshMysql.RepoCase, async: false
  alias AshMysql.Test.Post

  require Ash.Query

  test "unique constraint errors are properly caught" do
    post =
      Post
      |> Ash.Changeset.for_create(:create, %{title: "title"})
      |> Ash.create!()

    assert_raise Ash.Error.Invalid,
                 ~r/Invalid value provided for id: has already been taken/,
                 fn ->
                   Post
                   |> Ash.Changeset.for_create(:create, %{id: post.id})
                   |> Ash.create!()
                 end
  end

  test "unique constraint errors for identities are properly caught and custom message is used" do
    attrs = %{title: "title", uniq_one: "one", uniq_two: "two"}

    Post
    |> Ash.Changeset.for_create(:create, attrs)
    |> Ash.create!()

    assert_raise Ash.Error.Invalid,
                 ~r/Invalid value provided for uniq_one: uniq_one_and_two message/,
                 fn ->
                   Post
                   |> Ash.Changeset.for_create(:create, attrs)
                   |> Ash.create!()
                 end
  end

  # no upserts for now. hopefully later
  @tag :skip
  test "a unique constraint can be used to upsert when the resource has a base filter" do
    post =
      Post
      |> Ash.Changeset.for_create(:create, %{
        title: "title",
        uniq_one: "fred",
        uniq_two: "astair",
        price: 10
      })
      |> Ash.create!()

    new_post =
      Post
      |> Ash.Changeset.for_create(:create, %{
        title: "title2",
        uniq_one: "fred",
        uniq_two: "astair"
      })
      |> Ash.create!(upsert?: true, upsert_identity: :uniq_one_and_two)

    assert new_post.id == post.id
    assert new_post.price == 10
  end
end
