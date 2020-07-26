defmodule Enigma.Covers.Renderer do
  alias Enigma.Covers.{Cover, Shape}

  def render_cover(%Cover{} = cover) do
    """
    <svg width="#{cover.size}" 
         height="#{cover.size}" 
         viewBox="0 0 #{cover.size} #{cover.size}" 
         stroke="#000" 
         fill="#FFF">
      <rect x="0" y="0" width="#{cover.size}" height="#{cover.size}" />
      #{cover.shapes |> Enum.map(fn s -> render_shape(cover, s) end) |> Enum.join()}
    </svg>
    """
  end

  def render_shape(%Cover{} = cover, %Shape{variety: "rectangle"} = shape) do
    """
    <rect x="#{shape.x}" 
          y="#{shape.y}" 
          width="#{shape.width}%" 
          height="#{shape.height}%" 
          fill="#{shape.color}" 
          fill-opacity="#{shape.opacity}%" 
          transform="rotate(#{shape.rotation} #{cover.size / 2}, #{cover.size / 2})" 
    />
    """
  end

  def render_shape(%Cover{} = cover, %Shape{variety: "ellipse"} = shape) do
    """
    <ellipse cx="#{shape.x}" 
             cy="#{shape.y}" 
             rx="#{shape.width / 2}" 
             ry="#{shape.y / 2}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{cover.size / 2}, #{cover.size / 2})"
    />
    """
  end

  def render_shape(%Cover{} = cover, %Shape{variety: "triangle"} = shape) do
    """
    <polygon points="#{shape.x},#{shape.y} #{shape.x - shape.width},#{shape.y} #{shape.x},#{shape.y - shape.height}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{cover.size / 2}, #{cover.size / 2})" 
    />
    """
  end
end
