use Mix.Config

# Configure your database
config :flexcility, Flexcility.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "flexcility_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
