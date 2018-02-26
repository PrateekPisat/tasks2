defmodule Tasks2.SocialTest do
  use Tasks2.DataCase

  alias Tasks2.Social

  describe "posts" do
    alias Tasks2.Social.Post

    @valid_attrs %{body: "some body", completed: true, name: "some name"}
    @update_attrs %{body: "some updated body", completed: false, name: "some updated name"}
    @invalid_attrs %{body: nil, completed: nil, name: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Social.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Social.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Social.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.completed == true
      assert post.name == "some name"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Social.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.body == "some updated body"
      assert post.completed == false
      assert post.name == "some updated name"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_post(post, @invalid_attrs)
      assert post == Social.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Social.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Social.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Social.change_post(post)
    end
  end

  describe "post" do
    alias Tasks2.Social.Posts

    @valid_attrs %{body: "some body", completed: true, name: "some name"}
    @update_attrs %{body: "some updated body", completed: false, name: "some updated name"}
    @invalid_attrs %{body: nil, completed: nil, name: nil}

    def posts_fixture(attrs \\ %{}) do
      {:ok, posts} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Social.create_posts()

      posts
    end

    test "list_post/0 returns all post" do
      posts = posts_fixture()
      assert Social.list_post() == [posts]
    end

    test "get_posts!/1 returns the posts with given id" do
      posts = posts_fixture()
      assert Social.get_posts!(posts.id) == posts
    end

    test "create_posts/1 with valid data creates a posts" do
      assert {:ok, %Posts{} = posts} = Social.create_posts(@valid_attrs)
      assert posts.body == "some body"
      assert posts.completed == true
      assert posts.name == "some name"
    end

    test "create_posts/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Social.create_posts(@invalid_attrs)
    end

    test "update_posts/2 with valid data updates the posts" do
      posts = posts_fixture()
      assert {:ok, posts} = Social.update_posts(posts, @update_attrs)
      assert %Posts{} = posts
      assert posts.body == "some updated body"
      assert posts.completed == false
      assert posts.name == "some updated name"
    end

    test "update_posts/2 with invalid data returns error changeset" do
      posts = posts_fixture()
      assert {:error, %Ecto.Changeset{}} = Social.update_posts(posts, @invalid_attrs)
      assert posts == Social.get_posts!(posts.id)
    end

    test "delete_posts/1 deletes the posts" do
      posts = posts_fixture()
      assert {:ok, %Posts{}} = Social.delete_posts(posts)
      assert_raise Ecto.NoResultsError, fn -> Social.get_posts!(posts.id) end
    end

    test "change_posts/1 returns a posts changeset" do
      posts = posts_fixture()
      assert %Ecto.Changeset{} = Social.change_posts(posts)
    end
  end
end
