defmodule Enigma.ExampleTest do
  use Enigma.DataCase, async: true

  alias Enigma.Covers.{Cover, Example, Shape}

  test "shape generator" do
    Enum.each (0..1000), fn _ ->
      assert {:ok, %Shape{}} = Shape.create(Example.shape(:all))
    end
  end

  test "cover generator, with embedded shapes" do
    Enum.each (0..1000), fn _ ->
      assert {:ok, %Cover{} = cover} = Cover.create(Example.cover(:all, size: 100))
      Enum.each cover.shapes, fn shape ->
        assert %Shape{} = shape
      end
    end
  end
end
