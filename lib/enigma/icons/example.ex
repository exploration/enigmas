defmodule Enigma.Icons.Example do
  alias Enigma.Icons.{Icon,Shape}

  @moduledoc """
  Example parameter generators for various Enigma / Icon-related tasks
  """

  @doc """
  Returns a random hex color

  ## Examples

      iex> color()
      "#FAB234"
  """
  def color() do
    random_hex_digit = fn ->
      Enum.random(0..15)
      |> Integer.to_string(16)
    end

    prepend_hash = fn list -> ["#" | list] end

    1..6
    |> Enum.map(fn _ -> random_hex_digit.() end)
    |> prepend_hash.()
    |> Enum.join()
  end

  @doc """
  Given a list of example %Icon{} field names, returns an example map that contains matching valid attributes.

  Takes an optional second parameter, which is a keyword list of manual overrides for specific fields (which would typically be used with the `:all` option).

  ## Examples

      iex> icon :height
      %{height: 82}

      iex> icon [:height, :shape_count]
      %{
        height: 20, 
        shape_count: 3
      }

      iex> icon :all
      %{
        height: 82,
        shape_count: 3,
        shapes: [ %{...}, ... ]
        variety: "square"
        width: 100,
      }

      iex> icon :all, width: 100
      %{
        height: 44,
        shape_count: 3,
        shapes: [ %{...}, ... ],
        variety: "square"
        width: 100,
      }
  """
  def icon(opts, attrs \\ [])
  def icon(:all, attrs), do: icon([:height, :shape_count, :variety, :width], attrs)
  def icon(opt, attrs) when is_atom(opt), do: icon([opt], attrs)
  def icon(opts, attrs) when is_list(opts) do
    example = Enum.reduce(opts, %{}, fn
      :shape_count, acc -> Enum.into(%{shape_count: Enum.random(5..20)}, acc)
      :height, acc -> Enum.into(%{height: Enum.random(100..400)}, acc)
      :variety, acc -> Enum.into(%{variety: Enum.random(Icon.varieties())}, acc)
      :width, acc -> Enum.into(%{width: Enum.random(100..400)}, acc)
      _, acc -> acc
    end)

    example = Enum.reduce(attrs, example, fn {key, value}, acc ->
      Map.merge(acc, %{key => value})
    end)

    Map.merge(example, %{shapes:
      Enum.map(1..example.shape_count, fn i ->
        if example.shape_count > 1 and i == 1 do
          shape :all, color: "#F79421"
        else
          shape :all
        end
      end)
    })
  end

  @doc """
  Given a list of example %Shape{} field names, returns an example map that contains matching valid attributes.

  Takes an optional second parameter, which is a keyword list of manual overrides for specific fields (which would typically be used with the `:all` option).

  ## Examples

      iex> shape :height
      %{height: 82}

      iex> shape [:color, :opacity]
      %{color: "#5F5029", opacity: 50}

      iex> shape :all
      %{
          color: "#684381",
          height: 1,
          opacity: 78,
          rotation: 289,
          variety: "ellipse",
          width: 4
      }

      iex> shape :all, color: "#123456"
      %{
          color: "#123456",
          height: 1,
          opacity: 78,
          rotation: 289,
          variety: "ellipse",
          width: 4
      }
  """
  def shape(opts, attrs \\ [])

  def shape(:all, attrs),
    do: shape([:color, :height, :opacity, :rotation, :variety, :x, :width, :y], attrs)

  def shape(opt, attrs) when is_atom(opt), do: shape([opt], attrs)

  def shape(opts, attrs) when is_list(opts) do
    example =
      Enum.reduce(opts, %{}, fn
        :color, acc -> Enum.into(%{color: color()}, acc)
        :height, acc -> Enum.into(%{height: Enum.random(25..100)}, acc)
        :opacity, acc -> Enum.into(%{opacity: Enum.random(10..100)}, acc)
        :rotation, acc -> Enum.into(%{rotation: Enum.random(1..90)}, acc)
        :variety, acc -> Enum.into(%{variety: Enum.random(Shape.varieties())}, acc)
        :x, acc -> Enum.into(%{x: Enum.random(1..100)}, acc)
        :width, acc -> Enum.into(%{width: Enum.random(25..100)}, acc)
        :y, acc -> Enum.into(%{y: Enum.random(1..100)}, acc)
        _, acc -> acc
      end)

    Enum.reduce(attrs, example, fn {key, value}, acc ->
      Map.merge(acc, %{key => value})
    end)
  end
end
