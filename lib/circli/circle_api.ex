defmodule Circli.CircleApi do
  use Timex

  def fetch_me do
    circle_url = "https://circle2.bubtools.net/api/v1.1/me"
    circle_token = "a598c3e26d9b3bbf0fe1d44a1a045236e2522f77"
    response = HTTPotion.get(circle_url,
      query: %{"circle-token" => circle_token},
      headers: %{accept: "application/json"})

    {_, me_info} = Poison.decode(response.body)
    me_info
  end

  defp fetch_status(branch_name) do
    circle_url = "https://circle2.bubtools.net/api/v1.1/project/github/BookBub/lello/tree/#{branch_name}"
    circle_token = "a598c3e26d9b3bbf0fe1d44a1a045236e2522f77"

    response = HTTPotion.get(circle_url,
      query: %{"circle-token" => circle_token},
      headers: %{accept: "application/json"})

    {_, build_info} = Poison.decode(response.body)
    build_info
  end

  defp removeSuccessStates(builds) do
    Enum.reject(builds, fn build -> build["status"] == "success" end)
  end

  defp gather_build_state_messages(builds) do
    Enum.map(builds,
      fn build ->
        "#{build["build_parameters"]["CIRCLE_JOB"]} => #{build["status"]}"
      end)
  end

  def print_build_summary(branch_name) do
    build_status = fetch_status(branch_name)

    results = build_status |> removeSuccessStates |> gather_build_state_messages

    first_build = Enum.at(build_status, 0)
    committer_date = Timex.parse!(first_build["start_time"], "{ISO:Extended}")

    IO.puts ""
    IO.puts("------------------------------------------------------------")
    IO.puts("        branch: #{branch_name}")
    IO.puts("     committed: #{Timex.format!(committer_date, "{relative}", :relative)}")
    IO.puts("commit message: #{first_build["subject"]}")
    IO.puts("------------------------------------------------------------")

    if Enum.empty?(results) do
      IO.puts("build succeeded")
    else
      results |> Enum.uniq |> Enum.reverse |> Enum.each(fn r -> IO.puts(r) end)
    end

    IO.puts ""
  end
end

