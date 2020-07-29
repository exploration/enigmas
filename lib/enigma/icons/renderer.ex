defmodule Enigma.Icons.Renderer do
  alias Enigma.Icons.{Icon, Shape}

  def render_icon(%Icon{variety: "circle"} = icon) do
    """
    <svg version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         width="#{icon.size}" 
         height="#{icon.size}" 
         viewBox="0 0 #{icon.size} #{icon.size}" 
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
      #{icon.shapes |> Enum.map(fn s -> render_shape(icon, s) end) |> Enum.join()}
    </svg>
    """
  end

  def render_icon(%Icon{variety: "square"} = icon) do
    """
    <svg version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         width="#{icon.size}" 
         height="#{icon.size}" 
         viewBox="0 0 #{icon.size} #{icon.size}" 
         stroke="#233E52" 
         stroke-linejoin="round"
         stroke-width="2%"
         fill="#FFF">
      <rect x="0" 
            y="0" 
            width="#{icon.size}"
            height="#{icon.size}"
            stroke-width="8%"
            rx="5%"
            ry="5%" 
      />
      #{icon.shapes |> Enum.map(fn s -> render_shape(icon, s) end) |> Enum.join()}
    </svg>
    """
  end

  def render_shape(%Icon{} = icon, %Shape{variety: "rectangle"} = shape) do
    """
    <rect x="#{n shape.x, icon}" 
          y="#{n shape.y, icon}" 
          width="#{shape.width}%" 
          height="#{shape.height}%" 
          fill="#{shape.color}" 
          fill-opacity="#{shape.opacity}%" 
          transform="rotate(#{shape.rotation} #{icon.size / 2}, #{icon.size / 2})" 
          #{if icon.variety == "circle", do: "clip-path=\"url(#clip-text)\""}
    />
    """
  end

  def render_shape(%Icon{} = icon, %Shape{variety: "ellipse"} = shape) do
    """
    <ellipse cx="#{n shape.x, icon}" 
             cy="#{n shape.y, icon}" 
             rx="#{n(shape.width, icon) / 2}" 
             ry="#{n(shape.height, icon) / 2}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{icon.size / 2}, #{icon.size / 2})"
             #{if icon.variety == "circle", do: "clip-path=\"url(#clip-text)\""}
    />
    """
  end

  def render_shape(%Icon{} = icon, %Shape{variety: "triangle"} = shape) do
    """
    <polygon points="#{n shape.x, icon},#{n shape.y, icon} #{n(shape.x,icon) - n(shape.width, icon)},#{n shape.y,icon} #{n shape.x,icon},#{n(shape.y,icon) - n(shape.height,icon)}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{icon.size / 2}, #{icon.size / 2})" 
             #{if icon.variety == "circle", do: "clip-path=\"url(#clip-text)\""}
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
  
  defp n(percentage, %Icon{} = icon), do: normalize(percentage, icon.size)
end
