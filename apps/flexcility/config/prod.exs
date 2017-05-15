use Mix.Config

import_config "prod.secret.exs"

# config :bolt_sips, Bolt,
#   url: System.get_env("GRAPHENE_PROD_URL"),
#   basic_auth: [username: System.get_env("GRAPHENE_PROD_USERNAME"), password: System.get_env("GRAPHENE_PROD_PASSWORD")],
#   ssl: true

config :bolt_sips, Bolt,
  url: System.get_env("GRAPHENE_PROD_URL"),
  basic_auth: [username: System.get_env("GRAPHENE_PROD_USERNAME"), password: System.get_env("GRAPHENE_PROD_PASSWORD")],
  pool_size: 5,
  max_overflow: 1
