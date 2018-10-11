use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix14_base, Phoenix14BaseWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix14_base, Phoenix14Base.Repo,
  username: "postgres",
  password: "postgres",
  database: "phoenix14_base_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
