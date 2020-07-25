defmodule Enigma.ExampleTest do
  use Enigma.DataCase, async: true

  alias Enigma.Covers.{Example, Shape}

  test "shape generator" do
    Enum.each (0..1000), fn _ ->
      assert {:ok, %Shape{}} = Shape.create(Example.shape(:all))
    end
  end
end
