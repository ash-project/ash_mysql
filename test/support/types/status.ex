defmodule AshSqlite.Test.Types.Status do
  @moduledoc false
  use Ash.Type.Enum, values: [:open, :closed]

  def storage_type, do: :string
end
