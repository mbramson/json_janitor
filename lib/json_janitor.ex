defmodule JsonJanitor do
  @moduledoc """
  `JsonJanitor` helps sanitize elixir terms so that they can be serialized to
  JSON.
  """

  @doc """
  Accepts anything and returns a structure that can be serialized to JSON.

  This is useful in situations where you're not quite sure what can a function
  can receive, but you know it'll need to serialize to JSON.

  An example of such a situation is in a FallbackController of a Phoenix
  application. If you have a universal fallback and want to help callers of
  the API diagnose issues, you may want to return the fallback payload in the
  response. If that term happens to not be serializable to JSON then an
  internal server error will actually be returned. If `JsonJanitor.sanitize/1`
  is used first, then you can be sure that it will always send properly.

  Another example is when an external service such as Sentry is used to report
  errors. If additional metadata is supplied surrounding an error and it cannot
  be guaranteed to be serializable, then the call to Sentry itself can fail.
  Using `JsonJanitor.sanitize/1` on this data guarantees that the call will not
  fail because the data cannot serialize to JSON.

  ## Examples

      iex> JsonJanitor.sanitize([:ok, <<128>>])
      [":ok", "<<128>>"]

  Tuples are converted to lists.
      iex> JsonJanitor.sanitize({'cat'})
      ['cat']

  Keyword lists are converted to maps.

      iex> JsonJanitor.sanitize([option: 42])
      %{option: 42}

  Atoms are converted to strings unless they are keys of maps.

      iex> JsonJanitor.sanitize(%{horse: :dog})
      %{horse: ":dog"}

  Map keys are converted to binary strings even if they are complex.

      iex> JsonJanitor.sanitize(%{%{cat: 3} => {}})
      %{"%{cat: 3}" => []}

  Map keys that are atoms are not converted to strings. They are left as atoms.

      iex> JsonJanitor.sanitize(%{cat: 3})
      %{cat: 3}

  Binaries which cannot be printed are converted to strings of the raw bit
  data.

      iex> JsonJanitor.sanitize(<<128>>)
      "<<128>>"

  Structs are converted to maps and then their struct type is added to the map
  in the `:struct_type` key.

      iex> JsonJanitor.sanitize(%TestStruct{})
      %{struct_type: "TestStruct", purpose: "to purr", sound: "meow"}

  nil values are left as nil.

      iex> JsonJanitor.sanitize(nil)
      nil
  """
  @spec sanitize(term()) :: term()
  def sanitize(%_{} = struct) do
    struct
    |> Map.from_struct()
    |> Map.put(:struct_type, struct.__struct__)
    |> sanitize
  end

  def sanitize(map) when is_map(map) do
    Enum.into(map, %{}, fn {k, v} -> {sanitized_key_for_map(k), sanitize(v)} end)
  end

  def sanitize(nil), do: nil

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

  def sanitize(atom) when is_atom(atom), do: inspect(atom)

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
