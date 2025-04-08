defmodule AshMysql.Functions.Like do
  @moduledoc """
  Maps to the builtin mysql function `like`.
  """

  use Ash.Query.Function, name: :like, predicate?: true

  def args, do: [[:string, :string]]
end
