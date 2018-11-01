defmodule Phoenix14BaseWeb.PageController do
  use Phoenix14BaseWeb, :controller

  alias PhoenixGon.Controller, as: Gon

  def index(conn, _params) do
    conn
    |> Gon.put_gon(:test, "Hello, World!")
    |> render("index.html")
  end
end
