use Mix.Config

# Configure your database
config :flexcility, Flexcility.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "flexcility_dev",
  hostname: "localhost",
  pool_size: 10

config :bolt_sips, Bolt,
  hostname: 'localhost',
  basic_auth: [username: "neo4j", password: "hentamsajaLah"],
  port: 7687,
  pool_size: 5,
  max_overflow: 1
