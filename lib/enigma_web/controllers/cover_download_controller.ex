defmodule EnigmaWeb.CoverDownloadController do
  use EnigmaWeb, :controller
  alias Enigma.Covers.{Cover, Renderer}

  def show(conn, %{"id" => blob}) do
    {:ok, cover} = Cover.decode64 blob
    svg = Renderer.render_cover(cover) 
    send_download(conn, {:binary, svg}, filename: "enigma.svg")
  end
end
