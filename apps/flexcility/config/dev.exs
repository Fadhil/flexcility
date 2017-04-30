use Mix.Config

# Configure your database
config :flexcility, Flexcility.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "flexcility_dev",
  hostname: "localhost",
  pool_size: 10
