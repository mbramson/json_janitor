defmodule JsonJanitorTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  doctest JsonJanitor

  describe "sanitize/1" do
    property "does not error for any input" do
      check all input <- term() do
        JsonJanitor.sanitize(input)
      end
    end

    property "output from any input can be serialized to JSON" do
      check all input <- term() do
        result = JsonJanitor.sanitize(input)
        Jason.encode!(result)
      end
    end

    test "converts a tuple to a list" do
      assert JsonJanitor.sanitize({1, 2, 3}) == [1, 2, 3]
    end

    test "converts a keyword list to a map" do
      assert JsonJanitor.sanitize([cat: 3, dog: 4]) == %{cat: 3, dog: 4}
    end
    test "converts elements within a map" do
      assert JsonJanitor.sanitize(%{cat: {}}) == %{cat: []}
    end

    test "converts elements within a list" do
      assert JsonJanitor.sanitize([{}]) == [[]]
    end

    test "handles a struct properly" do
      struct = %TestStruct{}
      assert %{} = JsonJanitor.sanitize(struct)
    end

    test "handles nil" do
      assert JsonJanitor.sanitize(nil) == nil
    end
  end
end
