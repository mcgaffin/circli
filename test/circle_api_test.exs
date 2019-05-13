defmodule Circle2ApiTest do
  use ExUnit.Case
  doctest Circli.Circle2Api
  import Circli.Circle2Api

  test "everything is ok" do
    assert print_build_messages([]) == :ok
  end
end
