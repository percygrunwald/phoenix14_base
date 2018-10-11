defmodule Phoenix14Base.Repo do
  use Ecto.Repo,
    otp_app: :phoenix14_base,
    adapter: Ecto.Adapters.Postgres
end
