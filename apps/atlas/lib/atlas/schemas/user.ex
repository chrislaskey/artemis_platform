defmodule Atlas.User do
  use Atlas.Schema
  use Assoc.Schema, repo: Atlas.Repo

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :name, :string
    field :provider_data, :map
    field :provider_uid, :string

    has_many :user_roles, Atlas.UserRole, on_delete: :delete_all, on_replace: :delete
    has_many :roles, through: [:user_roles, :role]
    has_many :permissions, through: [:roles, :permissions]

    timestamps()
  end

  # Callbacks

  def updatable_fields, do: [
    :email,
    :name,
    :first_name,
    :last_name,
    :provider_uid,
    :provider_data
  ]

  def required_fields, do: [
    :email
  ]

  def updatable_associations, do: [
    user_roles: Atlas.UserRole
  ]

  def event_log_fields, do: [
    :id,
    :name
  ]

  # Changesets

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, updatable_fields())
    |> validate_required(required_fields())
    |> unique_constraint(:email)
  end
end