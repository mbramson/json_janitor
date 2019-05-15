# JsonJanitor

`JsonJanitor` helps sanitize elixir terms so that they can be serialized to JSON.

Documentation is located at [https://hexdocs.pm/json_janitor](https://hexdocs.pm/json_janitor)

## Installation

`JsonJanitor` can be installed by adding `json_janitor` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:json_janitor, "~> 1.0.0"}
  ]
end
```

## Examples

```elixir
iex(1)> Jason.encode!({:ok, [option: <<128>>]})
** (Protocol.UndefinedError) protocol Jason.Encoder not implemented for {:ok,
[option: <<128>>]}, Jason.Encoder protocol must always be explicitly
implemented. This protocol is implemented for: Any, Atom, BitString, Date,
DateTime, Decimal, Float, Integer, Jason.Fragment, List, Map, NaiveDateTime,
Time (jason) lib/jason.ex:150: Jason.encode!/2

iex(2)> sanitized = JsonJanitor.sanitize({:ok, [option: <<128>>]})
[":ok", %{option: "<<128>>"}]

iex(3)> Jason.encode!(sanitized)
"[\":ok\",{\"option\":\"<<128>>\"}]"
```

For more examples see https://hexdocs.pm/json_janitor/JsonJanitor.html#sanitize/1-examples
