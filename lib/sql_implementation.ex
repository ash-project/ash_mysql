defmodule AshMysql.SqlImplementation do
  @moduledoc false
  use AshSql.Implementation

  require Ecto.Query

  @impl true
  def manual_relationship_function, do: :ash_mysql_join

  @impl true
  def manual_relationship_subquery_function, do: :ash_mysql_subquery

  @impl true
  def strpos_function, do: "instr"

  @impl true
  def ilike?, do: false

  @impl true
  def expr(
        query,
        %like{arguments: [arg1, arg2], embedded?: pred_embedded?},
        bindings,
        embedded?,
        acc,
        type
      )
      when like in [AshMysql.Functions.Like, AshMysql.Functions.ILike] do
    {arg1, acc} =
      AshSql.Expr.dynamic_expr(query, arg1, bindings, pred_embedded? || embedded?, :string, acc)

    {arg2, acc} =
      AshSql.Expr.dynamic_expr(query, arg2, bindings, pred_embedded? || embedded?, :string, acc)

    inner_dyn =
      if like == AshMysql.Functions.Like do
        Ecto.Query.dynamic(like(^arg1, ^arg2))
      else
        Ecto.Query.dynamic(like(fragment("LOWER(?)", ^arg1), fragment("LOWER(?)", ^arg2)))
      end

    if type != Ash.Type.Boolean do
      {:ok, inner_dyn, acc}
    else
      {:ok, Ecto.Query.dynamic(type(^inner_dyn, ^type)), acc}
    end
  end

  def expr(
        query,
        %Ash.Query.Function.GetPath{
          arguments: [%Ash.Query.Ref{attribute: %{type: type}}, right]
        } = get_path,
        bindings,
        embedded?,
        acc,
        nil
      )
      when is_atom(type) and is_list(right) do
    if Ash.Type.embedded_type?(type) do
      type = determine_type_at_path(type, right)

      do_get_path(query, get_path, bindings, embedded?, acc, type)
    else
      do_get_path(query, get_path, bindings, embedded?, acc)
    end
  end

  def expr(
        query,
        %Ash.Query.Function.GetPath{
          arguments: [%Ash.Query.Ref{attribute: %{type: {:array, type}}}, right]
        } = get_path,
        bindings,
        embedded?,
        acc,
        nil
      )
      when is_atom(type) and is_list(right) do
    if Ash.Type.embedded_type?(type) do
      type = determine_type_at_path(type, right)
      do_get_path(query, get_path, bindings, embedded?, acc, type)
    else
      do_get_path(query, get_path, bindings, embedded?, acc)
    end
  end

  def expr(
        query,
        %Ash.Query.Function.GetPath{} = get_path,
        bindings,
        embedded?,
        acc,
        type
      ) do
    do_get_path(query, get_path, bindings, embedded?, acc, type)
  end

  # Honestly we need to either 1. not type cast or 2. build in type compatibility concepts
  # instead of `:same` we need an `ANY COMPATIBLE` equivalent.
  @cast_operands_for [:<>]

  def expr(
        query,
        %{
          __predicate__?: _,
          left: %Ash.Query.Ref{} = left,
          right: right,
          embedded?: pred_embedded?,
          operator: :==
        },
        bindings,
        embedded?,
        acc,
        _type
      )
      when is_integer(right) do
    {left_expr, acc} =
      AshSql.Expr.dynamic_expr(
        query,
        left,
        Map.put(bindings, :no_cast?, true),
        pred_embedded? || embedded?,
        nil,
        acc
      )

    {right_expr, acc} =
      AshSql.Expr.dynamic_expr(
        query,
        right,
        bindings,
        pred_embedded? || embedded?,
        nil,
        acc
      )

    {:ok, Ecto.Query.dynamic(^left_expr == ^right_expr), acc}
  end

  def expr(
        query,
        %mod{
          __predicate__?: _,
          left: left,
          right: right,
          embedded?: pred_embedded?,
          operator: operator
        },
        bindings,
        embedded?,
        acc,
        type
      )
      when operator in [:<>, :||, :&&] do
    {[left_type, right_type], _return_type} = mod |> determine_types([left, right])

    {left_expr, acc} =
      if left_type && operator in @cast_operands_for do
        {left_expr, acc} =
          AshSql.Expr.dynamic_expr(query, left, bindings, pred_embedded? || embedded?, nil, acc)

        left_type = parameterized_type(left_type, [])

        {type_expr(left_expr, left_type), acc}
      else
        AshSql.Expr.dynamic_expr(
          query,
          left,
          bindings,
          pred_embedded? || embedded?,
          left_type,
          acc
        )
      end

    {right_expr, acc} =
      if right_type && operator in @cast_operands_for do
        {right_expr, acc} =
          AshSql.Expr.dynamic_expr(query, right, bindings, pred_embedded? || embedded?, nil, acc)

        right_type = parameterized_type(left_type, [])

        {type_expr(right_expr, right_type), acc}
      else
        AshSql.Expr.dynamic_expr(
          query,
          right,
          bindings,
          pred_embedded? || embedded?,
          right_type,
          acc
        )
      end

    {expr, acc} =
      case operator do
        :<> ->
          AshSql.Expr.dynamic_expr(
            query,
            %Ash.Query.Function.Fragment{
              embedded?: pred_embedded?,
              arguments: [
                raw: "CONCAT( ",
                casted_expr: left_expr,
                raw: ", ",
                casted_expr: right_expr,
                raw: ")"
              ]
            },
            bindings,
            embedded?,
            type,
            acc
          )

        :|| ->
          AshSql.Expr.dynamic_expr(
            query,
            %Ash.Query.Function.Fragment{
              embedded?: pred_embedded?,
              arguments: [
                raw: "CASE WHEN (",
                casted_expr: left_expr,
                raw: " LIKE FALSE OR ",
                casted_expr: left_expr,
                raw: " IS NULL) THEN ",
                casted_expr: right_expr,
                raw: " ELSE ",
                casted_expr: left_expr,
                raw: " END"
              ]
            },
            bindings,
            embedded?,
            type,
            acc
          )

        :&& ->
          AshSql.Expr.dynamic_expr(
            query,
            %Ash.Query.Function.Fragment{
              embedded?: pred_embedded?,
              arguments: [
                raw: "CASE WHEN (",
                casted_expr: left_expr,
                raw: " LIKE FALSE OR ",
                casted_expr: left_expr,
                raw: " IS NULL) THEN ",
                casted_expr: left_expr,
                raw: " ELSE ",
                casted_expr: right_expr,
                raw: " END"
              ]
            },
            bindings,
            embedded?,
            type,
            acc
          )
      end

    {:ok, expr, acc}
  end

  @impl true
  def expr(
        _query,
        _expr,
        _bindings,
        _embedded?,
        _acc,
        _type
      ) do
    :error
  end

  @impl true
  def type_expr(expr, nil), do: expr

  def type_expr(expr, {tag, type}) when is_list(expr) and tag in [:array, :in] do
    Enum.map(expr, &uuid_expr(&1, type))
  end

  def type_expr(expr, {tag, _type}) when tag in [:array, :in] do
    expr
  end

  def type_expr(expr, type) when is_atom(type) do
    type = Ash.Type.get_type(type)

    expr = uuid_expr(expr, type)

    cond do
      !Ash.Type.ash_type?(type) ->
        Ecto.Query.dynamic(type(^expr, ^type))

      Ash.Type.storage_type(type, []) == :ci_string ->
        Ecto.Query.dynamic(fragment("(? COLLATE utf8mb4_0900_ai_ci)", ^expr))

      true ->
        Ecto.Query.dynamic(type(^expr, ^Ash.Type.storage_type(type, [])))
    end
  end

  def type_expr(expr, type) do
    expr = uuid_expr(expr, type)

    case type do
      {:parameterized, {inner_type, constraints}} ->
        if inner_type.type(constraints) == :ci_string do
          Ecto.Query.dynamic(fragment("(? COLLATE utf8mb4_0900_ai_ci)", ^expr))
        else
          Ecto.Query.dynamic(type(^expr, ^type))
        end

      nil ->
        expr

      type ->
        Ecto.Query.dynamic(type(^expr, ^type))
    end
  end

  defp uuid_expr(expr, {:parameterized, {Ash.Type.UUID.EctoType, _}}) when is_binary(expr) do
    case Ash.Type.dump_to_native(Ash.Type.UUID, expr) do
      {:ok, v} -> v
      _ -> expr
    end
  end

  defp uuid_expr(expr, _type) do
    expr
  end

  @impl true
  def table(resource) do
    AshMysql.DataLayer.Info.table(resource)
  end

  @impl true
  def schema(_resource) do
    nil
  end

  @impl true
  def repo(resource, _kind) do
    AshMysql.DataLayer.Info.repo(resource)
  end

  @impl true
  def multicolumn_distinct?, do: false

  @impl true
  def parameterized_type({:parameterized, _} = type, _) do
    type
  end

  def parameterized_type({:parameterized, _, _} = type, _) do
    type
  end

  def parameterized_type({:in, type}, constraints) do
    parameterized_type({:array, type}, constraints)
  end

  def parameterized_type({:array, type}, constraints) do
    case parameterized_type(type, constraints[:items] || []) do
      nil ->
        nil

      type ->
        {:array, type}
    end
  end

  def parameterized_type({type, constraints}, []) do
    parameterized_type(type, constraints)
  end

  def parameterized_type(type, constraints) do
    if Ash.Type.ash_type?(type) do
      cast_in_query? =
        if function_exported?(Ash.Type, :cast_in_query?, 2) do
          Ash.Type.cast_in_query?(type, constraints)
        else
          Ash.Type.cast_in_query?(type)
        end

      if cast_in_query? do
        type = Ash.Type.ecto_type(type)

        parameterized_type(type, constraints)
      else
        nil
      end
    else
      if is_atom(type) && :erlang.function_exported(type, :type, 1) do
        Ecto.ParameterizedType.init(type, constraints || [])
      else
        type
      end
    end
  end

  @impl true
  def determine_types(mod, args, returns \\ nil) do
    returns =
      case returns do
        {:parameterized, _} -> nil
        {:array, {:parameterized, _}} -> nil
        {:array, {type, constraints}} when type != :array -> {type, [items: constraints]}
        {:array, _} -> nil
        {type, constraints} -> {type, constraints}
        other -> other
      end

    {types, new_returns} = Ash.Expr.determine_types(mod, args, returns)

    {types, new_returns || returns}
  end

  defp do_get_path(
         query,
         %Ash.Query.Function.GetPath{arguments: [left, right], embedded?: pred_embedded?},
         bindings,
         embedded?,
         acc,
         _type \\ nil
       ) do
    field = Ash.Query.Ref.name(left)
    path = Enum.map(right, &to_string/1)

    expr =
      Ecto.Query.dynamic([row], json_extract_path(field(row, ^field), ^path))

    {expr, acc} =
      AshSql.Expr.dynamic_expr(
        query,
        %Ash.Query.Function.Fragment{
          embedded?: pred_embedded?,
          arguments: [
            raw: "json_unquote(",
            expr: expr,
            raw: ")"
          ]
        },
        bindings,
        embedded?,
        {Ash.Type.String.EctoType, []},
        acc
      )

    {:ok, expr, acc}
  end

  defp determine_type_at_path(type, path) do
    path
    |> Enum.reject(&is_integer/1)
    |> do_determine_type_at_path(type)
    |> case do
      nil ->
        nil

      {type, constraints} ->
        parameterized_type(type, constraints)
    end
  end

  defp do_determine_type_at_path([], _), do: nil

  defp do_determine_type_at_path([item], type) do
    case Ash.Resource.Info.attribute(type, item) do
      nil ->
        nil

      %{type: {:array, type}, constraints: constraints} ->
        constraints = constraints[:items] || []

        {type, constraints}

      %{type: type, constraints: constraints} ->
        {type, constraints}
    end
  end

  defp do_determine_type_at_path([item | rest], type) do
    case Ash.Resource.Info.attribute(type, item) do
      nil ->
        nil

      %{type: {:array, type}} ->
        if Ash.Type.embedded_type?(type) do
          type
        else
          nil
        end

      %{type: type} ->
        if Ash.Type.embedded_type?(type) do
          type
        else
          nil
        end
    end
    |> case do
      nil ->
        nil

      type ->
        do_determine_type_at_path(rest, type)
    end
  end
end
