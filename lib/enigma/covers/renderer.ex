defmodule Enigma.Covers.Renderer do
  alias Enigma.Covers.{Cover, Shape}

  def render_cover_circle(%Cover{} = cover) do
    """
    <svg width="#{cover.size}" 
         height="#{cover.size}" 
         viewBox="0 0 #{cover.size} #{cover.size}" 
         stroke="#233E52" 
         stroke-width="1.5%"
         fill="#FFF">
       <clipPath id="clip-text">
          <ellipse cx="50%" 
                   cy="50%" 
                   rx="50%" 
                   ry="50%" 
          />
      </clipPath>
      <ellipse cx="50%" 
               cy="50%" 
               rx="47.5%" 
               ry="47.5%" 
               stroke-width="5%"
      />
      #{cover.shapes |> Enum.map(fn s -> render_shape(cover, s) end) |> Enum.join()}
    </svg>
    """
  end

  def render_cover_rectangle(%Cover{} = cover) do
    """
    <svg width="#{cover.size}" 
         height="#{cover.size}" 
         viewBox="0 0 #{cover.size} #{cover.size}" 
         stroke="#233E52" 
         stroke-width="1.5%"
         fill="#FFF">
      <rect x="0" 
            y="0" 
            width="#{cover.size}"
            height="#{cover.size}"
            stroke-width="5%"
            rx="5%"
            ry="5%" 
      />
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
          clip-path="url(#clip-text)"
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
             clip-path="url(#clip-text)"
    />
    """
  end

  def render_shape(%Cover{} = cover, %Shape{variety: "triangle"} = shape) do
    """
    <polygon points="#{shape.x},#{shape.y} #{shape.x - shape.width},#{shape.y} #{shape.x},#{shape.y - shape.height}" 
             fill="#{shape.color}" 
             fill-opacity="#{shape.opacity}%" 
             transform="rotate(#{shape.rotation} #{cover.size / 2}, #{cover.size / 2})" 
             clip-path="url(#clip-text)"
    />
    """
  end
end
