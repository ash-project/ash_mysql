ExUnit.start()
ExUnit.configure(stacktrace_depth: 100)

AshMysql.TestRepo.start_link()

Ecto.Adapters.SQL.Sandbox.mode(AshMysql.TestRepo, :manual)
