defmodule JustrunitWeb.Router do
  use JustrunitWeb, :router
  use ErrorTracker.Web, :router

  import JustrunitWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JustrunitWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user

    plug Plug.Static,
      at: "/",
      from: :justrunit,
      gzip: false,
      only: ~w(assets fonts images favicon.ico robots.txt)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :error_tracker_access_check do
    plug JustrunitWeb.PermissionsChecker, %{"error_tracker_web_ui" => ["url"]}
  end

  scope "/", JustrunitWeb.Modules do
    pipe_through :browser

    live "/", Welcome.WelcomeLive, :welcome

    get "/unauthorized", Rap.UnauthorizedController, :index
  end

  scope "/", JustrunitWeb.Modules do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{JustrunitWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/sign-up", Accounts.SignUpLive, :sign_up
      live "/sign-in", Accounts.SignInLive, :sign_in
      live "/reset_password", Accounts.UserForgotPasswordLive, :new
      live "/reset_password/:token", Accounts.UserResetPasswordLive, :edit
    end

    post "/sign-in", Accounts.UserSessionController, :create
  end

  scope "/", JustrunitWeb do
    pipe_through [:browser]

    delete "/users/log_out", Modules.Accounts.UserSessionController, :delete

    live_session :current_user,
      on_mount: [{JustrunitWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  if Application.compile_env(:justrunit, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JustrunitWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
      error_tracker_dashboard("/errors", as: :error_tracker_dashboard_dev)
    end
  end

  scope "/", JustrunitWeb.Modules do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{JustrunitWeb.UserAuth, :ensure_authenticated}] do
      live "/settings", Accounts.SettingsLive, :settings
      live "/settings/change-allowance", Plans.ChangeAllowanceLive, :change_allowance
      live "/new-justbox", Justboxes.NewJustboxLive, :new_justbox
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/justboxes/", Justboxes.JustboxesListLive, :justboxes_list
      live "/justboxes/:page", Justboxes.JustboxesListLive, :justboxes_list
    end
  end

  scope "/", JustrunitWeb.Modules do
    pipe_through [:browser, :require_authenticated_user, :error_tracker_access_check]

    error_tracker_dashboard("/errors")
  end

  scope "/", JustrunitWeb.Modules do
    pipe_through :browser

    live "/:handle/:justbox_slug", Justboxes.ShowJustboxLive, :show_justbox
  end
end
