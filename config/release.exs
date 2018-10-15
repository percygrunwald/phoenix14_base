use Mix.Config

config :phoenix14_base, :env, (System.get_env("ENV") || "prod") |> String.to_atom()

config :phoenix14_base, Phoenix14BaseWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :phoenix14_base, Phoenix14Base.Repo, ssl: true
