defmodule Flexcility.Web.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  alias Flexcility.Accounts

  @moduledoc """
  Checks for token in header or params. A valid token contains a user id
  which we then use to get a user to assign to :current_user
  """

  def init(options) do
    options
  end

  def call(conn, _) do
    token = get_token(conn)
    result = validate_token(conn, token)
    case result do
      :missing_token ->
        conn |> put_status(401)
        |> json(%{errors: %{detail: :missing_valid_api_token }})
        |> halt#%{errors: %{detail: "Missing valid API token"}}) |> halt
      :invalid_token ->
        conn |> send_resp(401, %{error: %{detail: :invalid_api_token }}) |> halt
      { :authenticated, user } ->
        conn |> assign(:current_user, user)
    end
  end

  def get_token(conn) do
    case get_req_header(conn, "token") do
      [] ->
        get_token_from_params(conn)
      [token] ->
        token
    end
  end

  def get_token_from_params(conn) do
    conn.params["token"]
  end

  def validate_token(conn, token) do
    case token do
      nil -> :missing_token
      _ -> verify_token(conn, token)
    end
  end

  def verify_token(conn, token) do
    case Phoenix.Token.verify(conn, "user", token, max_age: 1209600) do
      {:ok, user_id} ->
        get_user(user_id)
      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def get_user(user_id) do
    case Accounts.get_user!(user_id) do
      {:ok, user_node} ->
        {:authenticated, user_node.properties}
      {:error, _} ->
        :invalid_token
    end
  end
end
