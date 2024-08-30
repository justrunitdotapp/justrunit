defmodule JustrunitWeb.PermissionsChecker do
  @moduledoc """
  Plug which checks if user has permissions given as input.
  """

  use JustrunitWeb, :verified_routes
  use JustrunitWeb, :controller
  import Ecto.Query
  alias JustrunitWeb.Modules.Accounts.User
  alias JustrunitWeb.Modules.Rap.Permissions
  alias Justrunit.Repo

  def init(required_permissions) do
    required_permissions
  end

  def call(conn, required_permission) do
    user =
      case Repo.preload(conn.assigns.current_user, :role) do
        nil -> {:error, :user_not_found}
        user -> user
      end

    if Permissions.user_has_permission?(user, required_permission) do
      conn
    else
      conn
      |> redirect(to: ~p"/unauthorized")
      |> halt()
    end
  end
end
