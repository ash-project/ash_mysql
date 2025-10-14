# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs.contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.Test.Author do
  @moduledoc false
  use Ash.Resource,
    domain: AshMysql.Test.Domain,
    data_layer: AshMysql.DataLayer

  mysql do
    table("authors")
    repo(AshMysql.TestRepo)
  end

  attributes do
    uuid_primary_key(:id, writable?: true)
    attribute(:first_name, :string, public?: true)
    attribute(:last_name, :string, public?: true)
    attribute(:bio, AshMysql.Test.Bio, public?: true)
    # attribute(:badges, {:array, :atom}, public?: true)
  end

  actions do
    default_accept(:*)
    defaults([:create, :read, :update, :destroy])
  end

  relationships do
    has_one(:profile, AshMysql.Test.Profile, public?: true)
    has_many(:posts, AshMysql.Test.Post, public?: true)
  end

  calculations do
    calculate(:title, :string, expr(bio[:title]))
    calculate(:full_name, :string, expr(first_name <> " " <> last_name))
    # calculate(:full_name_with_nils, :string, expr(string_join([first_name, last_name], " ")))
    # calculate(:full_name_with_nils_no_joiner, :string, expr(string_join([first_name, last_name])))
    # calculate(:split_full_name, {:array, :string}, expr(string_split(full_name)))

    calculate(:first_name_or_bob, :string, expr(first_name || "bob"))
    calculate(:first_name_and_bob, :string, expr(first_name && "bob"))

    calculate(
      :conditional_full_name,
      :string,
      expr(
        if(
          is_nil(first_name) or is_nil(last_name),
          "(none)",
          first_name <> " " <> last_name
        )
      )
    )

    calculate(
      :nested_conditional,
      :string,
      expr(
        if(
          is_nil(first_name),
          "No First Name",
          if(
            is_nil(last_name),
            "No Last Name",
            first_name <> " " <> last_name
          )
        )
      )
    )

    calculate :param_full_name,
              :string,
              {AshMysql.Test.Concat, keys: [:first_name, :last_name]} do
      argument(:separator, :string, default: " ", constraints: [allow_empty?: true, trim?: false])
    end
  end
end
