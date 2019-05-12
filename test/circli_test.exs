defmodule CircliTest do
  use ExUnit.Case
  doctest Circli.CLI
  doctest Circli.Util

  import Circli.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "parses build arguments" do
    assert parse_args([
      "-o", "org-name",
      "-r", "repo-name",
      "-b", "this-is-my-branch-name"
    ]) == { "org-name", "repo-name", "this-is-my-branch-name" }

    assert parse_args([
      "--organization=org-name",
      "--repo=repo-name",
      "--branch=this-is-my-branch-name"
    ]) == { "org-name", "repo-name", "this-is-my-branch-name" }
  end

  test "when passed nothing, returns nothing" do
    assert(parse_args([]) == {})
  end
end
