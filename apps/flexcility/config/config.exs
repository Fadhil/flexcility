use Mix.Config

config :flexcility, ecto_repos: [Flexcility.Repo]

import_config "#{Mix.env}.exs"
