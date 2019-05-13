defmodule Circli.Circle2Api do
  use Timex

  def fetch_me do
    circle_url = "https://circle2.bubtools.net/api/v1.1/me"
    circle_token = Application.get_env(:circli, :circle2_api_key)
    response = HTTPotion.get(circle_url,
      query: %{"circle-token" => circle_token},
      headers: %{accept: "application/json"})

    {_, me_info} = Poison.decode(response.body)
    me_info
  end

  defp fetch_status({ organization, repo, branch_name }) do
    circle_url = "https://circle2.bubtools.net/api/v1.1/project/github/#{organization}/#{repo}/tree/#{branch_name}"
    circle_token = Application.get_env(:circli, :circle2_api_key)

    response = HTTPotion.get(circle_url,
      query: %{
        "circle-token" => circle_token,
        limit: 60,
        shallow: true,
      },
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
        "#{build["workflows"]["job_name"]}: #{build["status"]}"
      end)
  end

  defp first_workflow([]) do
    IO.puts("")
    IO.puts("There are no builds on this branch yet. Get busy!")
    IO.puts("")
    []
  end

  defp first_workflow(builds) do
    most_recent_build = builds
                        |> Enum.reject(fn build -> build["committer_date"] === nil end)
                        |> Enum.at(0)

    workflow_id = most_recent_build["workflows"]["workflow_id"]
    Enum.reject(builds, fn build -> build["workflows"]["workflow_id"] != workflow_id end)
  end

  def first_queued_build(build, earliest_dt) do
    build_dt = Timex.parse!(build["queued_at"], "{ISO:Extended}")
    if Timex.compare(build_dt, earliest_dt) === -1, do: build_dt, else: earliest_dt
  end

  def gather_build_info([]) do
    %{}
  end

  def gather_build_info(build_states) do
    messages = build_states
              |> removeSuccessStates
              |> gather_build_state_messages

    queued_at = build_states |> Enum.reduce(Timex.now, &first_queued_build/2)

    commit_date = build_states
                  |> Enum.find(fn build -> build["committer_date"] != nil end)
                  |> Map.get("committer_date", "")
                  |> Timex.parse!("{ISO:Extended}")

    commit_message = build_states
                     |> Enum.find(fn build -> build["subject"] != nil end)
                     |> Map.get("subject")

    %{
      messages: messages,
      committed_at: commit_date,
      queued_at: queued_at,
      commit_message: commit_message,
    }
  end

  def generate_build_results(build_info) do 
    build_states = fetch_status(build_info)
                   |> first_workflow

    gather_build_info(build_states)
  end

  def print_build_messages([]) do
    IO.puts("✅  build succeeded")
  end

  def print_build_messages(messages) do
    messages
    |> Enum.uniq
    |> Enum.reverse
    |> Enum.each(fn r -> IO.puts("⚙️  #{r}") end)
  end

  defp validate_build_info({ organization, repo, branch }) do
    organization = if(organization == nil or String.length(organization) == 0, do: "bookbub", else: organization)
    repo = if(repo == nil or String.length(repo) == 0, do: "lello", else: repo)
    branch = if(branch == nil or String.length(branch) == 0, do: "master", else: branch)
    { organization, repo, branch }
  end

  def print_build_summary({}) do
    print_build_summary({ nil, nil, nil })
  end

  def print_build_summary({ nil, repo, branch }) do
    {org, _} = Circli.Util.git_repo_info()
    print_build_summary({ org, repo, branch })
  end

  def print_build_summary({ org, nil, branch }) do
    {_, repo} = Circli.Util.git_repo_info()
    print_build_summary({ org, repo, branch })
  end

  def print_build_summary({ org, repo, nil }) do
    print_build_summary({ org, repo, Circli.Util.current_branch() })
  end

  def print_build_summary(build_info) do
    results = build_info
              |> validate_build_info
              |> generate_build_results

    unless Enum.empty?(results) do
      border = String.duplicate("-", Enum.max([50, String.length(results[:commit_message]) + 16]))

      { org, repo, branch_name } = build_info
      IO.puts ""
      IO.puts(border)
      IO.puts("          repo: #{org}/#{repo}")
      IO.puts("        branch: #{branch_name}")
      IO.puts("     committed: #{Timex.format!(results[:committed_at], "{relative}", :relative)}")
      IO.puts("        queued: #{Timex.format!(results[:queued_at], "{relative}", :relative)}")
      IO.puts("commit message: #{results[:commit_message]}")
      IO.puts(border)
      IO.puts ""
      print_build_messages(results[:messages])
      IO.puts ""
    end
  end
end

