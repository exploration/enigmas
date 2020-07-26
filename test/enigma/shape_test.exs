defmodule Enigma.ShapeTest do
  use Enigma.DataCase, async: true

  alias Enigma.Covers.{Example, Shape}

  test "validate color format" do
    assert {:ok, %Shape{}} = Shape.create(shape())
    assert {:ok, %Shape{}} = Shape.create(shape color: "#123456")
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape color: "farts")
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape color: "#FAFA")
  end

  test "validate height" do
    assert {:ok, %Shape{}} = Shape.create(shape height: 0)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape height: 900)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape height: -10)
  end
  
  test "validate opacity" do
    assert {:ok, %Shape{}} = Shape.create(shape opacity: 0)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape opacity: 900)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape opacity: -10)
  end

  test "validate rotation" do
    assert {:ok, %Shape{}} = Shape.create(shape rotation: 0)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape rotation: 900)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape rotation: -10)
  end

  test "validate width" do
    assert {:ok, %Shape{}} = Shape.create(shape width: 0)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape width: 900)
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape width: -10)
  end

  test "validate variety" do
    assert {:ok, %Shape{}} = Shape.create(shape())
    assert {:error, %Ecto.Changeset{}} = Shape.create(shape variety: "zoinks")
  end

  defp shape(map \\ %{}) do
    Example.shape(:all, map)
  end
end
