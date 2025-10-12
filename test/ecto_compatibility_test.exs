# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.EctoCompatibilityTest do
  use AshMysql.RepoCase, async: false
  require Ash.Query

  test "call Ecto.Repo.insert! via Ash Repo" do
    org =
      %AshMysql.Test.Organization{
        id: Ash.UUID.generate(),
        name: "The Org"
      }
      |> AshMysql.TestRepo.insert!()

    assert org.name == "The Org"
  end
end
