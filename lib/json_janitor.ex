defmodule JsonJanitor do
  @moduledoc """
  Documentation for JsonJanitor.
  """

  @doc """
  Hello world.

  ## Examples

      #iex> JsonJanitor.hello()
      #:world

  """
  def sanitize(%_{} = struct) do
    struct
    |> Map.from_struct()
    |> Map.put(:struct_type, struct.__struct__)
    |> sanitize
  end

  def sanitize(map) when is_map(map) do
    Enum.into(map, %{}, fn {k, v} -> {sanitized_key_for_map(k), sanitize(v)} end)
  end

  def sanitize([]), do: []

  def sanitize(list) when is_list(list) do
    if Keyword.keyword?(list) do
      list
      |> Enum.into(%{})
      |> sanitize
    else
      Enum.map(list, fn value -> sanitize(value) end)
    end
  end

  def sanitize(reference) when is_reference(reference) do
    inspect(reference)
  end

  def sanitize(tuple) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> sanitize
  end

  def sanitize(binary) when is_binary(binary) do
    if String.printable?(binary) do
      binary
    else
      inspect(binary)
    end
  end

  def sanitize(other), do: other

  defp sanitized_key_for_map(binary) when is_binary(binary) do
    if String.printable?(binary) do
      binary
    else
      inspect(binary)
    end
  end
  defp sanitized_key_for_map(atom) when is_atom(atom), do: atom
  defp sanitized_key_for_map(key) do
    inspect(key)
  end
end
