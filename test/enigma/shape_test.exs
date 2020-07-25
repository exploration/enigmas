defmodule Enigma.ShapeTest do
  use Enigma.DataCase

  alias Enigma.Covers.Shape

  @valid_params %{
    color: "#FFF",
    height: 10,
    opacity: 50,
    rotation: 200,
    variety: "ellipse",
    width: 20
  }

  test "validate color format" do
    assert {:ok, %Shape{}} = Shape.create(@valid_params)
    assert {:ok, %Shape{}} = Shape.create(%{@valid_params | color: "#123456"})
    assert {:error, %Ecto.Changeset{}} = Shape.create(%{@valid_params | color: "farts"})
    assert {:error, %Ecto.Changeset{}} = Shape.create(%{@valid_params | color: "#FAFA"})
  end
  
  test "validate opacity" do
    assert {:ok, %Shape{}} = Shape.create(%{@valid_params | opacity: 0})
    assert {:error, %Ecto.Changeset{}} = Shape.create(%{@valid_params | opacity: 900})
    assert {:error, %Ecto.Changeset{}} = Shape.create(%{@valid_params | opacity: -10})
  end

  test "validate rotation" do
    assert {:ok, %Shape{}} = Shape.create(%{@valid_params | rotation: 0})
    assert {:error, %Ecto.Changeset{}} = Shape.create(%{@valid_params | rotation: 900})
    assert {:error, %Ecto.Changeset{}} = Shape.create(%{@valid_params | rotation: -10})
  end

  test "validate variety" do
    assert {:ok, %Shape{}} = Shape.create(@valid_params)
    assert {:error, %Ecto.Changeset{}} = Shape.create(%{@valid_params | variety: "zoinks"})
  end
end
