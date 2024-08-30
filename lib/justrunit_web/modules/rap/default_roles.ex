defmodule JustrunitWeb.Modules.Rap.DefaultRoles do
  @doc """
  Lists all default roles along with their permissions.
  """
  def all() do
    [
      %{
        name: "Admin",
        permissions: %{
          "error_tracker_web_ui" => ["url"]
        }
      },
      %{
        name: "User",
        permissions: %{
          # every role has to have permissions so user has this place-holder permission
          "default" => ["default"]
        }
      }
    ]
  end
end
