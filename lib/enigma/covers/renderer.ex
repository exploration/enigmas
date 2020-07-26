defmodule Enigma.Covers.Renderer do
  alias Enigma.Covers.{Cover, Shape}

  def render_cover(%Cover{variety: "circle"} = cover) do
    """
    <svg version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         width="#{cover.size}" 
         height="#{cover.size}" 
         viewBox="0 0 #{cover.size} #{cover.size}" 
         stroke="#233E52" 
         stroke-linejoin="round"
         stroke-width="2%"
         fill="#FFF">
      <clipPath id="clip-text">
        <ellipse cx="50%" cy="50%" rx="50%" ry="50%" fill-opacity="0" />
      </clipPath>
      <ellipse cx="50%" 
               cy="50%" 
               rx="48%" 
               ry="48%" 
               stroke-width="4%"
      />
      #{cover.shapes |> Enum.map(fn s -> render_shape(cover, s) end) |> Enum.join()}
    </svg>
    """
  end

  def render_cover(%Cover{variety: "square"} = cover) do
    """
    <svg version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         width="#{cover.size}" 
         height="#{cover.size}" 
         viewBox="0 0 #{cover.size} #{cover.size}" 
         stroke="#233E52" 
         stroke-linejoin="round"
         stroke-width="2%"
         fill="#FFF">
      <rect x="0" 
            y="0" 
            width="#{cover.size}"
            height="#{cover.size}"
            stroke-width="8%"
            rx="5%"
            ry="5%" 
      />
      #{cover.shapes |> Enum.map(fn s -> render_shape(cover, s) end) |> Enum.join()}
    </svg>
    """
  end

  def render_shape(%Cover{} = cover, %Shape{variety: "rectangle"} = shape) do
    """
    <rect x="#{n shape.x, cover}" 
          y="#{n shape.y, cover}" 
          width="#{shape.width}%" 
          height="#{shape.height}%" 
          fill="#{shape.color}" 
          fill-opacity="#{shape.opacity}%" 
          transform="rotate(#{shape.rotation} #{cover.size / 2}, #{cover.size / 2})" 
          #{if cover.variety == "circle", do: "clip-path=\"url(#clip-text)\""}
    />
    """
  end

  def render_shape(%Cover{} = cover, %Shape{variety: "ellipse"} = shape) do
    """
    <ellipse cx="#{n shape.x, cover}" 
             cy="#{n shape.y, cover}" 
             rx="#{n(shape.width, cover) / 2}" 
             ry="#{n(shape.height, cover) / 2}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{cover.size / 2}, #{cover.size / 2})"
             #{if cover.variety == "circle", do: "clip-path=\"url(#clip-text)\""}
    />
    """
  end

  def render_shape(%Cover{} = cover, %Shape{variety: "triangle"} = shape) do
    """
    <polygon points="#{n shape.x, cover},#{n shape.y, cover} #{n(shape.x,cover) - n(shape.width, cover)},#{n shape.y,cover} #{n shape.x,cover},#{n(shape.y,cover) - n(shape.height,cover)}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{cover.size / 2}, #{cover.size / 2})" 
             #{if cover.variety == "circle", do: "clip-path=\"url(#clip-text)\""}
    />
    """
  end

  @doc """
  When you're using SVG inline (ie as an embedded image instead of as an <SVG> tag, browsers need some strings replaced.
  """
  def filter_for_inline_svg(string) do
    String.replace(string, "#", "%23")
  end

  @doc """
  Normalize a percentage value (value out of 100) against a new range given by `0..maximum`.
  """
  def normalize(percentage, max) do
    ratio = Integer.floor_div(100, percentage)
    Integer.floor_div(max, ratio)
  end
  
  defp n(percentage, cover), do: normalize(percentage, cover.size)
end
