defmodule Phoenix14Base.EnvHelpers do
  @application :phoenix14_base

  def get_current_env, do: get_app_env()

  def current_env_is?(atom) when is_atom(atom), do: get_app_env() == atom

  def current_env_is?(binary) when is_binary(binary) do
    atom = String.to_atom(binary)
    get_app_env() == atom
  end

  def current_env_is?(_), do: false

  defp get_app_env, do: Application.get_env(@application, :env, :prod)
end
