defmodule Enigma.Repo do
  use Ecto.Repo,
    otp_app: :enigma,
    adapter: Ecto.Adapters.Postgres
end
