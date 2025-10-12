# SPDX-FileCopyrightText: 2024 Joel Kociolek
# SPDX-FileCopyrightText: 2020 Zach Daniel
#
# SPDX-License-Identifier: MIT

ExUnit.start()
ExUnit.configure(stacktrace_depth: 100)

AshMysql.TestRepo.start_link()

Ecto.Adapters.SQL.Sandbox.mode(AshMysql.TestRepo, :manual)
