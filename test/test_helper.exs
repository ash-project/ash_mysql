# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

ExUnit.start()
ExUnit.configure(stacktrace_depth: 100)

AshMysql.TestRepo.start_link()

Ecto.Adapters.SQL.Sandbox.mode(AshMysql.TestRepo, :manual)
