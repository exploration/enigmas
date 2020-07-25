# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :enigma,
  ecto_repos: [Enigma.Repo]

# Configures the endpoint
config :enigma, EnigmaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5ISvDvsKRc4lpXPuIsOw1t2X+S5H9KpoZ0QkXXPg3FTefKz9IeL6YRKLXBIcicll",
  render_errors: [view: EnigmaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Enigma.PubSub,
  live_view: [signing_salt: "S9lA0Ywi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
