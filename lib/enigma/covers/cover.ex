defmodule Enigma.Covers.Cover do
  @derive Jason.Encoder
  use Ecto.Schema
  import Ecto.Changeset
  alias Enigma.Covers.Shape

  @primary_key false

  embedded_schema do
    field :shape_count, :integer
    field :size, :integer
    embeds_many :shapes, Shape
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:shape_count, :size])
    |> validate_required([:shape_count, :size])
    |> cast_embed(:shapes)
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
end
