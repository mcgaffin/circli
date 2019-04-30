defmodule Circli.CircleApi do
  use Timex

  @doc """
  Returns information about you, the current user. The returned information
  is based on the API key that you provide.

  """
  def fetch_me do
    circle_url = "https://circle2.bubtools.net/api/v1.1/me"
    circle_token = Application.get_env(:circli, :circle2_api_key)
    response = HTTPotion.get(circle_url,
      query: %{"circle-token" => circle_token},
      headers: %{accept: "application/json"})

    {_, me_info} = Poison.decode(response.body)
    me_info
  end

  defp fetch_status(branch_name) do
    circle_url = "https://circle2.bubtools.net/api/v1.1/project/github/BookBub/lello/tree/#{branch_name}"
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

  defp first_lello_workflow(builds) do
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

  def generate_build_results(branch_name) do 
    build_states = fetch_status(branch_name)
                   |> first_lello_workflow

    messages = build_states
              |> removeSuccessStates
              |> gather_build_state_messages

    queued_at = build_states |> Enum.reduce(Timex.now, &first_queued_build/2)

    commit_date = build_states
                  |> Enum.find(fn build -> build["committer_date"] != nil end)
                  |> Map.get("committer_date")
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

  @doc """
  Given an empty array, prints a success message for the workflow. 
  """
  def print_build_messages([]) do
    IO.puts("✅  build succeeded")
  end

  @doc """
  Given a list of build messages, prints a header followed by a message for
  each message. Each message should represent a build that is either:
    * queued
    * in-progress
    * failed

  Builds that have succeeded should not be listed here.
  """
  def print_build_messages(messages) do
    IO.puts("⚙️  running builds")
    messages
    |> Enum.reverse
    |> Enum.each(fn r -> IO.puts("- #{r}") end)
  end

  @doc """
  Prints a summary of the status of the latest build on the given branch. This currently
  supports workflows on Circle 2. Workflows are essentially a collection of builds triggered
  by one commit.

  Example:
    print_build_summary("master")
  """
  def print_build_summary(branch_name) do
    results = generate_build_results(branch_name)

    border = String.duplicate("-", Enum.max([50, String.length(results[:commit_message]) + 16]))

    IO.puts ""
    IO.puts(border)
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

