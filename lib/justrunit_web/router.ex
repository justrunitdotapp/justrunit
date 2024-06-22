defmodule JustrunitWeb.Router do
  use JustrunitWeb, :router

  import JustrunitWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JustrunitWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JustrunitWeb.Modules do
    pipe_through :browser

    live "/", Welcome.WelcomeLive, :welcome
    live "/justboxes/:page", Justboxes.JustboxesListLive, :justboxes_list
    live "/settings", Accounts.SettingsLive, :settings
    live "/justboxes/new", Justboxes.JustboxesNewLive, :justboxes_new
    live "/:user/:justbox", Justboxes.ShowJustboxLive, :show_justbox
  end

  # Other scopes may use custom stacks.
  # scope "/api", JustrunitWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:justrunit, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JustrunitWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", JustrunitWeb.Modules do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{JustrunitWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/sign-up", Accounts.SignUpLive, :sign_up
      live "/sign-in", Accounts.SignInLive, :sign_in
      live "/users/reset_password", Accounts.UserForgotPasswordLive, :new
      live "/users/reset_password/:token", Accounts.UserResetPasswordLive, :edit
    end

    post "/sign_in", Accounts.UserSessionController, :create
  end

  scope "/", JustrunitWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{JustrunitWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
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
end
