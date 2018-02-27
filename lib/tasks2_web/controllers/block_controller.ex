defmodule Tasks2Web.BlockController do
  use Tasks2Web, :controller

  alias Tasks2.Time
  alias Tasks2.Time.Block

  action_fallback Tasks2Web.FallbackController

  def index(conn, _params) do
    blocks = Time.list_blocks()
    render(conn, "index.json", blocks: blocks)
  end

  def create(conn, %{"post_id" => post_id, "start_day" => start_day,
  "start_month" => start_month, "start_year" => start_year,
  "start_hour" => start_hour, "start_minute" => start_minute,
  "start_second" => start_second, "end_day" => end_day,
  "end_month" => end_month, "end_year" => end_year,
  "end_hour" => end_hour, "end_minute" => end_minute,
  "end_second" => end_second}) do
    start = %DateTime{year: start_year, month: start_month, day: start_day,
    hour: start_hour, minute: start_minute, second: start_second,
    zone_abbr: "AMT", time_zone: "America/Manaus",  utc_offset: -14400,
    std_offset: 0} |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
    end_time = %DateTime{year: end_year, month: end_month, day: end_day,
    hour: end_hour, minute: end_minute, second: end_second,
    zone_abbr: "AMT", time_zone: "America/Manaus",  utc_offset: -14400,
    std_offset: 0} |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
    post = Tasks2.Social.get_post!(post_id)
      with {:ok, %Block{} = block} <- Time.create_block(%{post_id: post_id,
      start: start, end: end_time}) do
        conn
        |> put_flash(:info, "block_created")
        |> redirect(to: user_path(conn, :show, get_session(conn, :user_id) |> Tasks2.Accounts.get_user!()))
      end
  end

  def show(conn, %{"id" => id}) do
    block = Time.get_block!(id)
    render(conn, "show.json", block: block)
  end

  def update(conn, %{"id" => id, "block" => %{"post_id" => post_id, "start_day" => start_day, "start_month" => start_month, "start_year" => start_year, "start_hour" => start_hour, "start_minute" => start_minute, "start_second" => start_second, "end_day" => end_day, "end_month" => end_month, "end_year" => end_year, "end_hour" => end_hour, "end_minute" => end_minute, "end_second" => end_second}}) do
    block = Time.get_block!(id)
    start = %DateTime{year: start_year, month: start_month, day: start_day, hour: start_hour, minute: start_minute, second: start_second, zone_abbr: "AMT", time_zone: "America/Manaus",  utc_offset: -14400, std_offset: 0} |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
    end_time = %DateTime{year: end_year, month: end_month, day: end_day, hour: end_hour, minute: end_minute, second: end_second, zone_abbr: "AMT", time_zone: "America/Manaus",  utc_offset: -14400, std_offset: 0} |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
    post = Tasks2.Social.get_post!(post_id)
      with {:ok, %Block{} = block} <- Time.update_block(block, %{post_id: post_id,start: start, end: end_time}) do
        conn
        |> put_flash(:info, "block updated")
        |> redirect(to: user_path(conn, :show, get_session(conn, :user_id) |> Tasks2.Accounts.get_user!()))
      end
  end

  def delete(conn, %{"id" => id}) do
    block = Time.get_block!(id)
    post = Tasks2.Social.get_post!(block.post_id)
    user = Tasks2.Accounts.get_user!(post.user_id)
    with {:ok, %Block{}} <- Time.delete_block(block) do
      conn
      |> put_flash(:info, "block Deleted")
      |> redirect(to: user_path(conn, :show, user))
    end
  end
end
