# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.TestRepo do
  @moduledoc false
  use AshMysql.Repo,
    otp_app: :ash_mysql
end
