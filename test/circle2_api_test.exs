defmodule Circle2ApiTest do
  use ExUnit.Case
  doctest Circli.Circle2Api

  import ExUnit.CaptureIO
  import Circli.Circle2Api

  test "prints success message when no builds have failed or are still running" do
    fun = fn ->
      assert print_build_messages([]) === :ok
    end

    assert capture_io(fun) == "√ build succeeded\n"
  end

  test "returns empty array and prints message if no builds were found" do
    fun = fn ->
      assert most_recent_workflow([]) === []
    end

    assert capture_io(fun) == "\nThere are no builds on this branch yet. Get busy!\n\n"
  end

  test "returns empty array and prints error message if builds could not be fetched" do
    error_message = "{ :conn_refused, :error }"
    fun = fn ->
      assert most_recent_workflow([{ :error, error_message }]) === []
    end

    assert capture_io(fun) == "\nThere was an error fetching the build status: #{error_message}\n\n"
  end
end
