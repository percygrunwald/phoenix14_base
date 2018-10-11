defmodule Phoenix14Base.ConfigTOMLTransform do
  @behaviour Toml.Transform

  @moduledoc """
  **Make sure that all maps are converted to keyword lists, otherwise it will not merge with
  existing config (e.g. items from `config.exs` or `release.exs`).**
  """

  @spec transform(any(), any()) :: any()
  def transform(:sync_nodes_optional, node_list) when is_list(node_list) do
    for node_binary when is_binary(node_binary) <- node_list, do: String.to_atom(node_binary)
  end

  def transform(:env, env_binary) when is_binary(env_binary) do
    String.to_atom(env_binary)
  end

  def transform(:logger, %{level: log_level} = logger_config) when is_binary(log_level) do
    put_config(logger_config, :level, String.to_atom(log_level))
  end

  def transform(_k, %{} = map_v) do
    Keyword.new(map_v)
  end

  def transform(_k, v), do: v

  defp put_config(%{} = config_item, key, value) do
    config_item
    |> Keyword.new()
    |> put_config(key, value)
  end

  defp put_config(config_item, key, value) when is_list(config_item) do
    Keyword.put(config_item, key, value)
  end
end
