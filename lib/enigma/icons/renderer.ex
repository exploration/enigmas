defmodule Enigma.Icons.Renderer do
  alias Enigma.Icons.{Icon, Shape}

  def render_icon(%Icon{variety: "circle"} = icon) do
    """
    <svg version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         width="#{icon.width}" 
         height="#{icon.height}" 
         viewBox="0 0 #{icon.width} #{icon.height}" 
         stroke="#{icon.stroke_color}" 
         stroke-linejoin="round"
         stroke-width="#{icon.stroke_width / 2}%"
         fill="#{icon.fill_color}">
      <clipPath id="clip-text">
        <ellipse cx="50%" 
                 cy="50%"
                 rx="50%" 
                 ry="50%" 
                 fill-opacity="0" 
        />
      </clipPath>
      <ellipse cx="50%" 
               cy="50%" 
               rx="#{50 - (icon.stroke_width / 2)}%" 
               ry="#{50 - (icon.stroke_width / 2)}%" 
               stroke-width="#{icon.stroke_width}%"
      />
      #{icon.shapes |> Enum.map(fn s -> render_shape(icon, s) end) |> Enum.join()}
    </svg>
    """
    |> String.trim()
  end

  def render_icon(%Icon{variety: "square"} = icon) do
    """
    <svg version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         width="#{icon.width}" 
         height="#{icon.height}" 
         viewBox="0 0 #{icon.width} #{icon.height}" 
         stroke="#{icon.stroke_color}" 
         stroke-linejoin="round"
         stroke-width="#{icon.stroke_width / 2}%"
         fill="#{icon.fill_color}">
      <rect x="0" 
            y="0" 
            width="100%"
            height="100%"
            stroke-width="#{icon.stroke_width * 2}%"
            rx="#{icon.stroke_width * 1.5}%"
            ry="#{icon.stroke_width * 1.5}%" 
      />
      #{icon.shapes |> Enum.map(fn s -> render_shape(icon, s) end) |> Enum.join()}
    </svg>
    """
    |> String.trim()
  end

  def render_shape(%Icon{} = icon, %Shape{variety: "rectangle"} = shape) do
    """
    #{if icon.variety == "circle", do: "<g clip-path=\"url(#clip-text)\">"}
    <rect x="#{n shape.x, icon.width}" 
          y="#{n shape.y, icon.height}" 
          width="#{shape.width}%" 
          height="#{shape.height}%" 
          fill="#{shape.color}" 
          fill-opacity="#{shape.opacity}%" 
          transform="rotate(#{shape.rotation} #{icon.width / 2}, #{icon.height / 2})" 
    />
    #{if icon.variety == "circle", do: "</g>"}
    """
  end

  def render_shape(%Icon{} = icon, %Shape{variety: "ellipse"} = shape) do
    """
    #{if icon.variety == "circle", do: "<g clip-path=\"url(#clip-text)\">"}
    <ellipse cx="#{n shape.x, icon.width}" 
             cy="#{n shape.y, icon.height}" 
             rx="#{n(shape.width, icon.width) / 2}" 
             ry="#{n(shape.height, icon.height) / 2}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{icon.width / 2}, #{icon.height / 2})"
    />
    #{if icon.variety == "circle", do: "</g>"}
    """
  end

  def render_shape(%Icon{} = icon, %Shape{variety: "triangle"} = shape) do
    """
    #{if icon.variety == "circle", do: "<g clip-path=\"url(#clip-text)\">"}
    <polygon points="#{n shape.x, icon.width},#{n shape.y, icon.height} #{n(shape.x,icon.width) - n(shape.width, icon.width)},#{n shape.y,icon.height} #{n shape.x,icon.height},#{n(shape.y,icon.height) - n(shape.height,icon.height)}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{icon.width / 2}, #{icon.height / 2})" 
    />
    #{if icon.variety == "circle", do: "</g>"}
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

  def n(percentage, max), do: normalize(percentage, max)
end
