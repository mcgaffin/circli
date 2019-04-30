defmodule CircleApiTest do
  use ExUnit.Case
  doctest Circli.CircleApi

  import Circli.CircleApi

  test "everything is ok" do
    assert print_build_messages([]) == :ok
  end
end
