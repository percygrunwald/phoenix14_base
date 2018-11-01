defmodule Phoenix14Base.EnvHelpersHelpersTest do
  use ExUnit.Case, async: true

  alias Phoenix14Base.EnvHelpers

  test "env helpers" do
    assert EnvHelpers.get_current_env() == :test
    assert EnvHelpers.current_env_is?(:test)
    refute EnvHelpers.current_env_is?(:dev)
    refute EnvHelpers.current_env_is?(:not_an_env)
    assert EnvHelpers.current_env_is?("test")
    refute EnvHelpers.current_env_is?("dev")
    refute EnvHelpers.current_env_is?("not an env")
    refute EnvHelpers.current_env_is?(123)
  end
end
