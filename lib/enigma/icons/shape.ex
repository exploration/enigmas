defmodule Enigma.Icons.Shape do
  @derive Jason.Encoder
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :color, :string
    field :height, :integer
    field :opacity, :integer
    field :rotation, :integer
    field :variety, :string
    field :x, :integer
    field :width, :integer
    field :y, :integer
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:color, :height, :opacity, :rotation, :variety, :x, :width, :y, ])
    |> validate_required([:color, :height, :opacity, :rotation, :variety, :x, :width, :y, ])
    |> validate_format(:color, ~r/^#([[:xdigit:]]{3}){1,2}$/)
    |> validate_number(:height, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:opacity, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:rotation, greater_than_or_equal_to: 0, less_than_or_equal_to: 360)
    |> validate_number(:width, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_variety()
  end

  @doc """
  Given a map of attrs, create a `%Shape{}`.

  Returns `{:ok, %Shape{}}` on success, `{:error, %Ecto.Changeset}` on error. See `Ecto.Changeset.apply_action/2` for more detail.
  """
  def create(attrs) do
    changeset(%__MODULE__{}, attrs)
    |> apply_action(:create)
  end

  @doc """
  A list of the potential valid shape varieties
  """
  def varieties do
    ["ellipse", "rectangle", "triangle"]
  end

  defp validate_variety(changeset) do
    case get_change(changeset, :variety) do
      nil ->
        changeset

      variety ->
        if variety in varieties() do
          changeset
        else
          add_error(changeset, :variety, "not recognized")
        end
    end
  end
end
