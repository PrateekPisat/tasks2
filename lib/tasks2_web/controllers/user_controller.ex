defmodule Tasks2Web.UserController do
  use Tasks2Web, :controller

  alias Tasks2.Accounts
  alias Tasks2.Accounts.User
  alias Tasks2.Accounts.Manage
  alias Tasks2.Social
  alias Tasks2.Social.Post
  alias Tasks2Web.PageController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    users = Accounts.list_users
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    users = Accounts.list_users
      case Accounts.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_session(:user_id, user.id)
          |> redirect(to: manage_path(conn, :new))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset, users: users)
      end
  end

  def show(conn, %{"id" => id}) do
      users = Accounts.list_users
      user = Tasks2.Accounts.get_user!(get_session(conn, :user_id))
      post = Social.get_all_posts(id)
      manager = Accounts.get_manager!(user.id)
        underlings_managed = Accounts.get_underlings(user.id)#[{%Manage}, ...]
        underlings = get_underlings(underlings_managed, [])
        underling_posts = get_tasks(underlings, [])
        render(conn, "show.html", user: user, post: post,
        manager: manager,
        underlings: underlings,
        underling_posts: underling_posts,
        users: users,
        )
  end

  defp get_underlings([h|t], underlings) do
    cond do
      t == [] ->
        underlings = underlings ++ [Accounts.get_user!(h.underling_id)]
      true ->
        underlings = underlings ++ [Accounts.get_user!(h.underling_id)]
        get_underlings(t, underlings)
    end
  end

  defp get_underlings([], []), do: []

  defp get_tasks([h|t], tasks) do
    cond do
      t == [] ->
      tasks = tasks ++ Social.get_all_posts(h.id)
      true ->
      tasks = tasks ++ Social.get_all_posts(h.id)
      get_tasks(t, tasks)
    end
  end

  defp get_tasks([], []) do
    []
  end


  def edit(conn, %{"id" => id}) do
    users = Accounts.list_users
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, users: users, current_user: Tasks2.Accounts.get_user!(get_session(conn, :user_id)))
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    users = Accounts.list_users
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
      {:ok, _user} = Accounts.delete_user(user)
      conn
      |> delete_session(:user_id)
      |> put_flash(:info, "User deleted successfully.")
      |> redirect(to: "/")
  end


end
