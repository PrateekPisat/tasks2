defmodule Tasks2Web.PostController do
  use Tasks2Web, :controller

  alias Tasks2.Social
  alias Tasks2.Social.Post
  alias Tasks2.Accounts
  alias Tasks2.Accounts.User
  alias Tasks2.Time

  def index(conn, _params) do
    posts = Social.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    user = Tasks2.Accounts.get_user!(get_session(conn, :user_id))
    users = get_users(Accounts.get_underlings(get_session(conn, :user_id)), []) ++ [user]
    changeset = Social.change_post(%Post{})
    render(conn, "new.html", changeset: changeset, users: users, current_user: user = Tasks2.Accounts.get_user!(get_session(conn, :user_id)))
  end

  defp get_users([h|t], users) do
    cond do
      t == [] ->
        users = users ++ [Accounts.get_user!(h.underling_id)]
      true ->
        users = users ++ [Accounts.get_user!(h.underling_id)]
        get_users(t, users)
    end
  end

  defp get_users([], []), do: []

  def create(conn, %{"post" => post_params}) do
    user = Accounts.get_user!(get_session(conn, :user_id))
    users = Accounts.list_users
      err = try do
        post_user = Accounts.get_user!(post_params["user_id"])
        case Social.create_post(post_params) do
          {:ok, post} ->
            conn
            |> put_flash(:info, "Task assigned to #{post_user.name}.")
            |> redirect(to: user_path(conn, :show, user))
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset, users: users, current_user: user = Tasks2.Accounts.get_user!(get_session(conn, :user_id)))
        end
        rescue
        Ecto.NoResultsError ->
          changeset = Social.change_post(%Post{})
          conn
          |> put_flash(:error, "Please select a User_id from the list mentioned in the page.")
          |> render("new.html", users: users, changeset: changeset, current_user: user = Tasks2.Accounts.get_user!(get_session(conn, :user_id)))
      end
  end

  def show(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    user = Accounts.get_user!(post.user_id)
    if Time.get_block_by_post(post.id) do
      block = Time.get_block!(Time.get_block_by_post(post.id).id)
      start_time = block.start
      end_time = block.end
      changeset = Time.change_block(block)
    end
    render(conn, "show.html", post: post, user: user, current_user: user = Tasks2.Accounts.get_user!(get_session(conn, :user_id)), block: block,
    start_time: start_time, end_time: end_time, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    user = Accounts.get_user!(post.user_id)
    users = get_users(Accounts.get_underlings(get_session(conn, :user_id)), []) ++ [user]
    changeset = Social.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, user: user, users: users)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Social.get_post!(id)
    user = Accounts.get_user!(post.user_id)
    users = Accounts.list_users
    changeset = Social.change_post(post)
      case Social.update_post(post, post_params) do
        {:ok, post} ->
          conn
          |> put_flash(:info, "Task updated successfully.")
          |> redirect(to: user_path(conn, :show, Tasks2.Accounts.get_user!(get_session(conn, :user_id))))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", post: post, changeset: changeset)
      end
  end

  def delete(conn, %{"id" => id}) do
    post = Social.get_post!(id)
    user = Accounts.get_user!(post.user_id)
    {:ok, _post} = Social.delete_post(post)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: user_path(conn, :show, user))
  end
end
