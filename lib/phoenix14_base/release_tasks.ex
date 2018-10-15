defmodule Phoenix14Base.ReleaseTasks do
  @application :phoenix14_base
  @migrate_deps [:postgrex, :ecto, :ssl]
  @repo Phoenix14Base.Repo

  @doc """
  Runs DB migrations as a release task.

  Please see the README for instructions on running release tasks. See `rel/commands/` for
  accompanying shell script.
  """
  def migrate() do
    IO.puts("Loading #{@application}...")
    _status = Application.load(@application)

    IO.puts("Starting dependencies necessary for migrations...")
    Enum.each(@migrate_deps, &Application.ensure_all_started/1)

    IO.puts("Starting repo...")
    @repo.start_link(pool_size: 1)

    IO.puts("Running migrations for #{@application}...")
    Ecto.Migrator.run(@repo, migrations_path(@application), :up, all: true)

    IO.puts("Migration completed successfully")
    :init.stop()
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"
end
