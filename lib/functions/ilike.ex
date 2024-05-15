defmodule AshMysql.Functions.ILike do
  @moduledoc """
  Maps to the builtin mysql function `ilike`.
  """

  use Ash.Query.Function, name: :ilike

  def args, do: [[:string, :string]]
end
