defmodule Enigma.Covers.Shape do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @varieties ["ellipse", "rectangle", "triangle"]

  embedded_schema do
    field :color, :string
    field :height, :integer
    field :opacity, :integer
    field :rotation, :integer
    field :variety, :string
    field :width, :integer
  end

  @doc false
  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:color, :opacity, :rotation, :width, :height, :variety])
    |> validate_required([:color, :opacity, :rotation, :width, :height])
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
  Given a list of example field names, returns an example map that contains matching valid attributes.

  ## Examples
  
      iex> example_params :height
      %{height: 82}

      iex> example_params [:color, :opacity]
      %{color: "#5F5029", opacity: 50}

      iex> example_params :all
      %{
          color: "#684381",
          height: 1,
          opacity: 78,
          rotation: 289,
          variety: "ellipse",
          width: 4
      }
  """
  def example_params(attrs) when is_list(attrs) do
    Enum.reduce(attrs, %{}, fn
      :color, acc -> 
        Enum.into %{color: example_color()}, acc
      :height, acc ->  
        Enum.into %{height: Enum.random (1..100)}, acc
      :opacity, acc ->  
        Enum.into %{opacity: Enum.random (1..100)}, acc
      :rotation, acc ->  
        Enum.into %{rotation: Enum.random (1..360)}, acc
      :variety, acc ->  
        Enum.into %{variety: Enum.random(@varieties)}, acc
      :width, acc ->  
        Enum.into %{width: Enum.random (1..100)}, acc
      _, acc -> acc
    end)
  end

  def example_params(:all), do: example_params([:color, :height, :opacity, :rotation, :variety, :width])

  def example_params(attr) when is_atom(attr), do: example_params([attr])

  defp example_color() do
    random_hex_digit = fn ->
      Enum.random((0..15)) 
      |> Integer.to_string(16) 
    end
    prepend_hash = fn list -> ["#" | list] end

    (1..6)
    |> Enum.map(fn _ -> random_hex_digit.() end)
    |> prepend_hash.()
    |> Enum.join()
  end

  defp validate_variety(changeset) do
    case get_change(changeset, :variety) do
      nil -> 
        changeset
      variety ->
        if variety in @varieties do
          changeset
        else
          add_error(changeset, :variety, "not recognized")
        end
    end
  end
end
