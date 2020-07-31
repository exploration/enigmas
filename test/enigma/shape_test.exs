defmodule Enigma.ShapeTest do
  use Enigma.DataCase, async: true

  alias Enigma.Icons.{Example, Shape}

  test "validate color format" do
    assert {:ok, %Shape{}} = Shape.create(shape())
    assert {:ok, %Shape{}} = Shape.create(shape color: "#123456")
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape color: "farts")
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape color: "#FAFA")
  end

  test "validate percentage fields" do
    Enum.each [:height, :opacity, :rotation, :x, :width, :y], fn field ->
      assert {:ok, %Shape{}} = Shape.create(shape [{field, 0}])
      assert {:error, %Ecto.Changeset{}} = Shape.create(shape [{field, 900}])
      assert {:error, %Ecto.Changeset{}} = Shape.create(shape [{field, -10}])
    end
  end

  test "validate variety" do
    assert {:ok, %Shape{}} = Shape.create(shape())
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape variety: "zoinks")
  end

  defp shape(map \\ %{}) do
    Example.shape(:all, map)
  end
end
