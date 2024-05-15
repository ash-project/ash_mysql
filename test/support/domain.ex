defmodule AshMysql.Test.Domain do
  @moduledoc false
  use Ash.Domain

  resources do
    resource(AshMysql.Test.Post)
    resource(AshMysql.Test.Comment)
    resource(AshMysql.Test.IntegerPost)
    resource(AshMysql.Test.Rating)
    resource(AshMysql.Test.PostLink)
    resource(AshMysql.Test.PostView)
    resource(AshMysql.Test.Author)
    resource(AshMysql.Test.Profile)
    resource(AshMysql.Test.User)
    resource(AshMysql.Test.Account)
    resource(AshMysql.Test.Organization)
    resource(AshMysql.Test.Manager)
  end

  authorization do
    authorize(:when_requested)
  end
end
