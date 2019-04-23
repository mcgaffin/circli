defmodule Circli do
  @moduledoc """
  Documentation for Circli.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Circli.hello()
      :world

  """
  def hello do
    :world
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [foo: :string]
    )
    options
  end

  def process([]) do
    IO.puts "gimme some arguments"
  end

  def process(options) do
    IO.puts "circle => #{options[:name]}"
  end

  def main(args) do
    IO.puts "This is Circli"
    args |> parse_args |> process
  end
end
