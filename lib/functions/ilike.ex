defmodule AshMysql.Functions.ILike do
  @moduledoc """
  Maps to the builtin mysql function `ilike`.
  """

  use Ash.Query.Function, name: :ilike, predicate?: true

  def args, do: [[:string, :string]]
end
