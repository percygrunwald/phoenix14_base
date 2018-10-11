use Mix.Config

config :phoenix14_base,
  ecto_repos: [Phoenix14Base.Repo]

config :phoenix14_base, Phoenix14Base.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool_size: 10

config :phoenix14_base, Phoenix14BaseWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: Phoenix14BaseWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phoenix14Base.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger,
  backends: [:console],
  utc_log: true

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason

if Enum.member?([:dev, :test], Mix.env()) do
  import_config("#{Mix.env()}.exs")
else
  import_config("release.exs")
end
