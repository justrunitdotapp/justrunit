defmodule JustrunitWeb.Modules.Rap.Permissions do
  import Ecto.Changeset

  def all() do
    %{
      "error_tracker_web_ui" => ["url"],
      "default" => ["default"]
    }
  end

  def validate_permissions(changeset, field) do
    validate_change(changeset, field, fn _field, permissions ->
      permissions
      |> Enum.reject(&has_permission?(all(), &1))
      |> case do
        [] -> []
        invalid_permissions -> [{field, {"invalid permissions", invalid_permissions}}]
      end
    end)
  end

  def has_permission?(permissions, {name, actions}) do
    Map.has_key?(permissions, name) && actions_valid?(name, actions, permissions)
  end

  defp actions_valid?(permission_name, given_action, permissions) when is_binary(given_action) do
    actions_valid?(permission_name, [given_action], permissions)
  end

  defp actions_valid?(permission_name, given_actions, permissions) when is_list(given_actions) do
    defined_actions = Map.get(permissions, permission_name)
    Enum.all?(given_actions, &(&1 in defined_actions))
  end

  @doc """
  Checks if user has permission(s) specified in `permission`.

  Requires a `user` record with preloaded `role` as a first argument.
  """
  def user_has_permission?(user, permission) when is_tuple(permission) do
    has_permission?(user.role.permissions, permission) ||
      has_permission?(user.custom_permissions, permission)
  end

  def user_has_permission?(user, permission) when is_map(permission) do
    {permission} = permission |> Map.to_list() |> List.to_tuple()

    has_permission?(user.role.permissions, permission) ||
      has_permission?(user.custom_permissions, permission)
  end
end
