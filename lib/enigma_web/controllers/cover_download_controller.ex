defmodule EnigmaWeb.CoverDownloadController do
  use EnigmaWeb, :controller
  alias Enigma.Covers.{Cover, Renderer}

  def show(conn, %{"id" => blob} = params) do
    {:ok, cover} = Cover.decode64 blob
    IO.inspect params
    svg = case params do
      %{"variety" => "rectangle"} ->
        Renderer.render_cover_rectangle(cover) 
      _ -> 
        Renderer.render_cover_circle(cover) 
    end
    send_download(conn, {:binary, svg}, filename: "enigma.svg")
  end
end
