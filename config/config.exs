# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :dobar, Dobar.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "CsINj8BieS6I5H8N9As30aIv32qdG6fJhJySPs9Lvv69w8PT17w6eBZUxsitUXpM",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Dobar.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
      issuer: "Dobar",
      ttl: { 30, :days },
      verify_issuer: true,
      secret_key: "j8vaBNDTAaUwpy2dycY52ju4tsnBj6Me+oKHziGTALGI4WN6Z9uhdW9VjZS4spuF",
      serializer: Dobar.GuardianSerializer

config :arc,
  bucket: "dobar-dev",
  virtual_host: true

config :ex_aws,
  region: "eu-central-1",
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]
