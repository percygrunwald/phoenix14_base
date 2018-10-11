defmodule Phoenix14BaseWeb.PageController do
  use Phoenix14BaseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
