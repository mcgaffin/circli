defmodule Circli do
  @moduledoc """
  Documentation for Circli.
  """

  # defp parse_args(args) do
  #   {options, _, _} = OptionParser.parse(args,
  #     switches: [foo: :string]
  #   )
  #   options
  # end

  def process([]) do
    IO.puts "gimme some arguments"
  end

  def process(options) do
    IO.puts "circle => #{options[:name]}"
  end

  @doc """
  Circli
  ======

  Circli prints the latest build summary for a givent branch. 

  Run it like:

  > circli dm-education-quiz
  """
  def main(args) do
    # args |> parse_args |> process

    CircleApi.print_build_summary(Enum.at(args, 0))
  end
end
