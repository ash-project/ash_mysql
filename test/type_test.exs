# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.TypeTest do
  use AshMysql.RepoCase, async: false
  alias AshMysql.Test.Post

  require Ash.Query

  test "uuids can be used as strings in fragments" do
    uuid = Ash.UUID.generate()

    Post
    |> Ash.Query.filter(fragment("? = ?", id, type(^uuid, :uuid)))
    |> Ash.read!()
  end
end
