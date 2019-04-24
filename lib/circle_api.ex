defmodule CircleApi do
  def fetch_me do
    circle_url = "https://circle2.bubtools.net/api/v1.1/me"
    circle_token = "a598c3e26d9b3bbf0fe1d44a1a045236e2522f77"
    response = HTTPotion.get(circle_url,
      query: %{"circle-token" => circle_token},
      headers: %{accept: "application/json"})

    {_, me_info} = Poison.decode(response.body)
    me_info
  end

  def fetch_status do
    circle_url = "https://circle2.bubtools.net/api/v1.1/project/github/BookBub/lello/tree/dm-education-quiz"
    circle_token = "a598c3e26d9b3bbf0fe1d44a1a045236e2522f77"
    response = HTTPotion.get(circle_url,
      query: %{"circle-token" => circle_token},
      headers: %{accept: "application/json"})

    {_, build_info} = Poison.decode(response.body)
    build_info
  end

  def fetch_build_summary do
    build_status = fetch_status()
    results = Enum.map(build_status,
      fn build -> "#{build["build_parameters"]["CIRCLE_JOB"]} => #{build["status"]}" end)

    first_build = Enum.at(build_status, 0)
    IO.puts ""
    IO.puts("============================================================")
    IO.puts("     committed: #{first_build["committer_date"]}")
    IO.puts("commit message: #{first_build["subject"]}")
    IO.puts("============================================================")

    results |> Enum.uniq |> Enum.reverse |> Enum.each(fn r -> IO.puts(r) end)

    IO.puts ""
  end
end

