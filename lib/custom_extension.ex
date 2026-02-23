# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.CustomExtension do
  @moduledoc """
  A custom extension implementation.
  """

  @callback install(version :: integer) :: String.t()

  @callback uninstall(version :: integer) :: String.t()

  defmacro __using__(name: name, latest_version: latest_version) do
    quote do
      @behaviour AshMysql.CustomExtension

      @extension_name unquote(name)
      @extension_latest_version unquote(latest_version)

      def extension, do: {@extension_name, @extension_latest_version, &install/1, &uninstall/1}
    end
  end
end
