# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :flexcility_web,
  namespace: Flexcility.Web,
  ecto_repos: []

# Configures the endpoint
config :flexcility_web, Flexcility.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "T7sFduXIZ3eswC9wy/e8MkhPBI8KIoIxK3DV9Te7aWyGB+oWIVj8/l8ljYZyHNsv",
  render_errors: [view: Flexcility.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Flexcility.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
