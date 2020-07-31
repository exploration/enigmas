defmodule Enigma.IconTest do
  use Enigma.DataCase, async: true

  alias Enigma.Icons.{Example, Icon}

  test "validate color formats" do
    Enum.each [:fill_color, :stroke_color], fn field ->
      assert {:ok, %Icon{}} = Icon.create(icon())
      assert {:ok, %Icon{}} = Icon.create(icon [{field, "#123456"}])
      assert {:error, %Ecto.Changeset{}} = Icon.create(icon [{field, "farts"}])
      assert {:error, %Ecto.Changeset{}} = Icon.create(icon [{field, "#FAFA"}])
    end
  end

  defp icon(map \\ %{}) do
    Example.icon(:all, map)
  end
end
