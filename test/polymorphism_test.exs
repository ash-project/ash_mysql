# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.PolymorphismTest do
  use AshMysql.RepoCase, async: false
  alias AshMysql.Test.{Post, Rating}

  require Ash.Query

  test "you can create related data" do
    Post
    |> Ash.Changeset.for_create(:create, rating: %{score: 10})
    |> Ash.create!()

    assert [%{score: 10}] =
             Rating
             |> Ash.Query.set_context(%{data_layer: %{table: "post_ratings"}})
             |> Ash.read!()
  end

  test "you can read related data" do
    Post
    |> Ash.Changeset.for_create(:create, rating: %{score: 10})
    |> Ash.create!()

    assert [%{score: 10}] =
             Post
             |> Ash.Query.load(:ratings)
             |> Ash.read_one!(authorize?: false)
             |> Map.get(:ratings)
  end
end
