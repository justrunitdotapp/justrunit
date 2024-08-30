defmodule JustrunitWeb.Modules.Rap.UnauthorizedController do
  use JustrunitWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(:index)
  end
end
