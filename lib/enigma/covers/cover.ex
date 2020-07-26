defmodule Enigma.Covers.Cover do
  @derive Jason.Encoder
  use Ecto.Schema
  import Ecto.Changeset
  alias Enigma.Covers.Shape

  @primary_key false

  embedded_schema do
    field :shape_count, :integer
    field :size, :integer
    field :variety, :string
    embeds_many :shapes, Shape
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:shape_count, :size, :variety])
    |> cast_embed(:shapes)
    |> validate_required([:shape_count, :size, :variety])
    |> validate_variety()
  end

  @doc """
  Given a map of attrs, create a `%Cover{}`.

  Returns `{:ok, %Cover{}}` on success, `{:error, %Ecto.Changeset}` on error. See `Ecto.Changeset.apply_action/2` for more detail.
  """
  def create(attrs) do
    changeset(%__MODULE__{}, attrs)
    |> apply_action(:create)
  end

  @doc "Convert a Base64-encoded string into a %Cover{}"
  def decode64(blob) when is_binary(blob) do
    blob
    |> Base.url_decode64!
    |> Jason.decode!
    |> create
  end

  @doc "Convert a %Cover{} into a Base64-encoded string"
  def encode64(%__MODULE__{} = cover) do
    cover
    |> Jason.encode!
    |> Base.url_encode64
  end

  @doc """
  A list of the potential valid shape varieties
  """
  def varieties do
    ["circle", "square"]
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
