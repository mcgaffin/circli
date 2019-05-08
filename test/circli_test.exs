defmodule CircliTest do
  use ExUnit.Case
  doctest Circli.CLI
  doctest Circli.Util

  import Circli.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "parses branch name" do
    assert parse_args(["this-is-my-branch-name"]) == { "this-is-my-branch-name" }
  end
end
