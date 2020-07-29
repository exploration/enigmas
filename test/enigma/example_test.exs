defmodule Enigma.ExampleTest do
  use Enigma.DataCase, async: true

  alias Enigma.Icons.{Icon, Example, Shape}

  test "shape generator" do
    Enum.each (0..1000), fn _ ->
      assert {:ok, %Shape{}} = Shape.create(Example.shape(:all))
    end
  end

  test "icon generator, with embedded shapes" do
    Enum.each (0..1000), fn _ ->
      assert {:ok, %Icon{} = icon} = Icon.create(Example.icon(:all, size: 100))
      Enum.each icon.shapes, fn shape ->
        assert %Shape{} = shape
      end
    end
  end
end
