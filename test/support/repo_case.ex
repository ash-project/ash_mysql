# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.RepoCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias AshMysql.TestRepo

      import Ecto
      import Ecto.Query
      import AshMysql.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Sandbox.checkout(AshMysql.TestRepo)

    unless tags[:async] do
      Sandbox.mode(AshMysql.TestRepo, {:shared, self()})
    end

    :ok
  end
end
