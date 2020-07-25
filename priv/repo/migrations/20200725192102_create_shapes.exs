defmodule Enigma.Repo.Migrations.CreateShapes do
  use Ecto.Migration

  def change do
    create table(:shapes) do
      add :color, :string
      add :opacity, :integer
      add :rotation, :integer
      add :width, :integer
      add :height, :integer
      add :variety, :string

      timestamps()
    end

  end
end
