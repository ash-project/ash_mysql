# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.CustomIndexTest do
  use AshMysql.RepoCase, async: false
  alias AshMysql.Test.Post

  require Ash.Query

  test "unique constraint errors are properly caught" do
    Post
    |> Ash.Changeset.for_create(:create, %{
      title: "first",
      uniq_custom_one: "what",
      uniq_custom_two: "what2"
    })
    |> Ash.create!()

    assert_raise Ash.Error.Invalid,
                 ~r/Invalid value provided for uniq_custom_one: dude what the heck/,
                 fn ->
                   Post
                   |> Ash.Changeset.for_create(:create, %{
                     title: "first",
                     uniq_custom_one: "what",
                     uniq_custom_two: "what2"
                   })
                   |> Ash.create!()
                 end
  end
end
