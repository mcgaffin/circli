defmodule CircliTest do
  use ExUnit.Case
  doctest Circli

  test "greets the world" do
    assert Circli.hello() == :world
  end
end
