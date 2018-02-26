defmodule Tasks2Web.ManageController do
  use Tasks2Web, :controller

  alias Tasks2.Accounts
  alias Tasks2.Accounts.Manage

  def index(conn, _params) do
    manages = Accounts.list_manages()
    render(conn, "index.html", manages: manages)
  end

  def new(conn, _params) do
    changeset = Accounts.change_manage(%Manage{})
    current_user = Accounts.get_user!(get_session(conn, :user_id))
    users = Accounts.list_users
    render(conn, "new.html", changeset: changeset, users: users, current_user: current_user)
  end

  def create(conn, %{"manage" => manage_params}) do
    users = Accounts.list_users
    current_user = Accounts.get_user!(get_session(conn, :user_id))
    case Accounts.create_manage(manage_params) do
      {:ok, manage} ->
        conn
        |> put_flash(:info, "Manage created successfully.")
        |> redirect(to: user_path(conn, :show, current_user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, users: users, current_user: current_user)
    end
  end

  def show(conn, %{"id" => id}) do
    manage = Accounts.get_manage!(id)
    render(conn, "show.html", manage: manage)
  end

  def edit(conn, %{"id" => id}) do
      users = Accounts.list_users
    manage = Accounts.get_manage!(id)
    current_user = Accounts.get_user!(get_session(conn, :user_id))
    changeset = Accounts.change_manage(manage)
    render(conn, "edit.html", manage: manage, changeset: changeset, current_user: current_user, users: users)
  end

  def update(conn, %{"id" => id, "manage" => manage_params}) do
      users = Accounts.list_users
    manage = Accounts.get_manage!(id)
    current_user = Accounts.get_user!(get_session(conn, :user_id))
    case Accounts.update_manage(manage, manage_params) do
      {:ok, manage} ->
        conn
        |> put_flash(:info, "Manage updated successfully.")
        |> redirect(to: user_path(conn, :show, current_user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", manage: manage, changeset: changeset, current_user: current_user, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    manage = Accounts.get_manage!(id)
    {:ok, _manage} = Accounts.delete_manage(manage)

    conn
    |> put_flash(:info, "Manage deleted successfully.")
    |> redirect(to: manage_path(conn, :index))
  end
end
