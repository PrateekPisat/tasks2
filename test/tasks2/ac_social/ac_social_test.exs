defmodule Tasks2.AcSocialTest do
  use Tasks2.DataCase

  alias Tasks2.AcSocial

  describe "posts" do
    alias Tasks2.AcSocial.Post

    @valid_attrs %{body: "some body", completed: true, name: "some name"}
    @update_attrs %{body: "some updated body", completed: false, name: "some updated name"}
    @invalid_attrs %{body: nil, completed: nil, name: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AcSocial.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert AcSocial.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert AcSocial.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = AcSocial.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.completed == true
      assert post.name == "some name"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AcSocial.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = AcSocial.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.body == "some updated body"
      assert post.completed == false
      assert post.name == "some updated name"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = AcSocial.update_post(post, @invalid_attrs)
      assert post == AcSocial.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = AcSocial.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> AcSocial.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = AcSocial.change_post(post)
    end
  end
end
