use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :tasks2, Tasks2Web.Endpoint,
  secret_key_base: "0VKe379UnRAXIBEnWQyKV/4lGhpY0XbV8vLCIaeCRR+ZJoVE9TBDnWAnxwyOMSG/"

# Configure your database
config :tasks2, Tasks2.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "tasks2",
  password: "Pradnya&1",
  database: "tasks2_prod",
  pool_size: 15
