defmodule Tasks2.ManagerAccountsTest do
  use Tasks2.DataCase

  alias Tasks2.ManagerAccounts

  describe "managers" do
    alias Tasks2.ManagerAccounts.Manager

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def manager_fixture(attrs \\ %{}) do
      {:ok, manager} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ManagerAccounts.create_manager()

      manager
    end

    test "list_managers/0 returns all managers" do
      manager = manager_fixture()
      assert ManagerAccounts.list_managers() == [manager]
    end

    test "get_manager!/1 returns the manager with given id" do
      manager = manager_fixture()
      assert ManagerAccounts.get_manager!(manager.id) == manager
    end

    test "create_manager/1 with valid data creates a manager" do
      assert {:ok, %Manager{} = manager} = ManagerAccounts.create_manager(@valid_attrs)
      assert manager.name == "some name"
    end

    test "create_manager/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ManagerAccounts.create_manager(@invalid_attrs)
    end

    test "update_manager/2 with valid data updates the manager" do
      manager = manager_fixture()
      assert {:ok, manager} = ManagerAccounts.update_manager(manager, @update_attrs)
      assert %Manager{} = manager
      assert manager.name == "some updated name"
    end

    test "update_manager/2 with invalid data returns error changeset" do
      manager = manager_fixture()
      assert {:error, %Ecto.Changeset{}} = ManagerAccounts.update_manager(manager, @invalid_attrs)
      assert manager == ManagerAccounts.get_manager!(manager.id)
    end

    test "delete_manager/1 deletes the manager" do
      manager = manager_fixture()
      assert {:ok, %Manager{}} = ManagerAccounts.delete_manager(manager)
      assert_raise Ecto.NoResultsError, fn -> ManagerAccounts.get_manager!(manager.id) end
    end

    test "change_manager/1 returns a manager changeset" do
      manager = manager_fixture()
      assert %Ecto.Changeset{} = ManagerAccounts.change_manager(manager)
    end
  end
end
