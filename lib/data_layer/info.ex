# SPDX-FileCopyrightText: 2024 ash_mysql contributors <https://github.com/ash-project/ash_mysql/graphs/contributors>
#
# SPDX-License-Identifier: MIT

defmodule AshMysql.DataLayer.Info do
  @moduledoc "Introspection functions for "

  alias Spark.Dsl.Extension

  @doc "The configured repo for a resource"
  def repo(resource) do
    Extension.get_opt(resource, [:mysql], :repo, nil, true)
  end

  @doc "The configured table for a resource"
  def table(resource) do
    Extension.get_opt(resource, [:mysql], :table, nil, true)
  end

  @doc "The configured references for a resource"
  def references(resource) do
    Extension.get_entities(resource, [:mysql, :references])
  end

  @doc "The configured reference for a given relationship of a  resource"
  def reference(resource, relationship) do
    resource
    |> Extension.get_entities([:mysql, :references])
    |> Enum.find(&(&1.relationship == relationship))
  end

  @doc "A keyword list of customized migration types"
  def migration_types(resource) do
    Extension.get_opt(resource, [:mysql], :migration_types, [])
  end

  @doc "A keyword list of customized migration defaults"
  def migration_defaults(resource) do
    Extension.get_opt(resource, [:mysql], :migration_defaults, [])
  end

  @doc "A list of attributes to be ignored when generating migrations"
  def migration_ignore_attributes(resource) do
    Extension.get_opt(resource, [:mysql], :migration_ignore_attributes, [])
  end

  @doc "The configured custom_indexes for a resource"
  def custom_indexes(resource) do
    Extension.get_entities(resource, [:mysql, :custom_indexes])
  end

  @doc "The configured custom_statements for a resource"
  def custom_statements(resource) do
    Extension.get_entities(resource, [:mysql, :custom_statements])
  end

  @doc "The configured polymorphic_reference_on_delete for a resource"
  def polymorphic_on_delete(resource) do
    Extension.get_opt(resource, [:mysql, :references], :polymorphic_on_delete, nil, true)
  end

  @doc "The configured polymorphic_reference_on_update for a resource"
  def polymorphic_on_update(resource) do
    Extension.get_opt(resource, [:mysql, :references], :polymorphic_on_update, nil, true)
  end

  @doc "The configured polymorphic_reference_name for a resource"
  def polymorphic_name(resource) do
    Extension.get_opt(resource, [:mysql, :references], :polymorphic_on_delete, nil, true)
  end

  @doc "The configured polymorphic? for a resource"
  def polymorphic?(resource) do
    Extension.get_opt(resource, [:mysql], :polymorphic?, nil, true)
  end

  @doc "The configured unique_index_names"
  def unique_index_names(resource) do
    Extension.get_opt(resource, [:mysql], :unique_index_names, [], true)
  end

  @doc "The configured exclusion_constraint_names"
  def exclusion_constraint_names(resource) do
    Extension.get_opt(resource, [:mysql], :exclusion_constraint_names, [], true)
  end

  @doc "The configured identity_index_names"
  def identity_index_names(resource) do
    Extension.get_opt(resource, [:mysql], :identity_index_names, [], true)
  end

  @doc "Identities not to include in the migrations"
  def skip_identities(resource) do
    Extension.get_opt(resource, [:mysql], :skip_identities, [], true)
  end

  @doc "The configured foreign_key_names"
  def foreign_key_names(resource) do
    Extension.get_opt(resource, [:mysql], :foreign_key_names, [], true)
  end

  @doc "Whether or not the resource should be included when generating migrations"
  def migrate?(resource) do
    Extension.get_opt(resource, [:mysql], :migrate?, nil, true)
  end

  @doc "A list of keys to always include in upserts."
  def global_upsert_keys(resource) do
    Extension.get_opt(resource, [:mysql], :global_upsert_keys, [])
  end

  @doc "A stringified version of the base_filter, to be used in a where clause when generating unique indexes"
  def base_filter_sql(resource) do
    Extension.get_opt(resource, [:mysql], :base_filter_sql, nil)
  end

  @doc "Skip generating unique indexes when generating migrations"
  def skip_unique_indexes(resource) do
    Extension.get_opt(resource, [:mysql], :skip_unique_indexes, [])
  end
end
