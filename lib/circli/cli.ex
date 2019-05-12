defmodule Circli.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that end up
  generating a table of the last _n_ issues in a github project
  """
  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  defp process(:help) do
    IO.puts """

      Usage: circli <lello-branch-name>

    """
    System.halt(0)
  end

  defp process({ branch_name }) do
    Circli.Circle2Api.print_build_summary(branch_name)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
    Otherwise it is a lello branch-name

  Prints a build summary for the latest commit of the provided branch.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean], aliases: [ h: :help ])
    case parse do
      { [ help: true ], _, _ }
      -> :help
        { _, [ branch_name ], _ }
        -> { branch_name }
      _ -> :help
    end
  end
end
