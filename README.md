# JsonJanitor

[![CircleCI][circle-img]][circle] [![Hex Version][hex-img]][hex] [![Hex Downloads][downloads-img]][downloads] [![License][license-img]][license]

[circle-img]: https://circleci.com/gh/mbramson/json_janitor/tree/master.svg?style=svg
[circle]: https://circleci.com/gh/mbramson/json_janitor/tree/master
[hex-img]: https://img.shields.io/hexpm/v/json_janitor.svg
[hex]: https://hex.pm/packages/json_janitor
[downloads-img]: https://img.shields.io/hexpm/dt/json_janitor.svg
[downloads]: https://hex.pm/packages/json_janitor
[license-img]: https://img.shields.io/badge/license-MIT-blue.svg
[license]: http://opensource.org/licenses/MIT

`JsonJanitor` sanitizes elixir terms so that they can be serialized to JSON.

It makes some opinionated decisions to keep as much structure as possible while
guaranteeing that the resulting structure can be serialized to JSON.

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

Not all terms can be serialized to JSON using `Poison` or `Jason`. When
serializing some terms, an error will be thrown.

```elixir
iex> Jason.encode!({:ok, [option: <<128>>]})
** (Protocol.UndefinedError) protocol Jason.Encoder not implemented for {:ok,
[option: <<128>>]}, Jason.Encoder protocol must always be explicitly
implemented. This protocol is implemented for: Any, Atom, BitString, Date,
DateTime, Decimal, Float, Integer, Jason.Fragment, List, Map, NaiveDateTime,
Time (jason) lib/jason.ex:150: Jason.encode!/2
```

By using `JsonJanitor` on terms before they are sanitized, it can be guaranteed
that the terms will serialize into a structure that does not obfuscate the
meaning or intention of the original term.

```elixir
iex> sanitized = JsonJanitor.sanitize({:ok, [option: <<128>>]})
[":ok", %{option: "<<128>>"}]

iex> Jason.encode!(sanitized)
"[\":ok\",{\"option\":\"<<128>>\"}]"
```

For more examples see https://hexdocs.pm/json_janitor/JsonJanitor.html#sanitize/1-examples
