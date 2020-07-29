defmodule EnigmaWeb.IconDownloadController do
  use EnigmaWeb, :controller
  alias Enigma.Icons.{Icon, Renderer}

  def show(conn, %{"id" => blob}) do
    {:ok, icon} = Icon.decode64 blob
    svg = Renderer.render_icon(icon) 
    send_download(conn, {:binary, svg}, filename: "enigma.svg")
  end
end
