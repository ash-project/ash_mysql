defmodule AshMysql.TestRepo do
  @moduledoc false
  use AshMysql.Repo,
    otp_app: :ash_mysql
end
