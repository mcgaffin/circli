defmodule Circle2ApiTest do
  use ExUnit.Case
  doctest Circli.Circle2Api
  import Circli.Circle2Api

  test "everything is ok" do
    assert print_build_messages([]) === :ok
  end

  test "returns empty array and prints message if no builds were found" do
    assert most_recent_workflow([]) === []
  end

  test "returns empty array and prints error message if builds could not be fetched" do
    assert most_recent_workflow([{ :error, "{ :conn_refused, :error }" }]) === []
  end
end
