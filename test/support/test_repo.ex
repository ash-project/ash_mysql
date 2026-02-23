# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.TestRepo do
  @moduledoc false
  use AshMysql.Repo,
    otp_app: :ash_mysql
end
