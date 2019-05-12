defmodule Circli.Util do
  @doc """
  Determines the name of the current git branch.
  If the current directory is part of a git repo, it will return: `{"current-branch-name", 0}`
  If the current directory is not part of a git repo, it will return: `{"", 128}`
  """
  def current_branch do
    {branch_name, 0} = System.cmd("git", ["symbolic-ref", "--short", "HEAD"])
    String.trim_trailing(branch_name)
  end

  @doc """
  Find the name of the git repo from the current directory. This occurs 
  by looking for a directory named `.git`. If that is found, then the current directory is
  determined to be the base of a git repo.

  If not, then we check the parent, then its parent, until we find a git repo or run out of directories.

      iex> Circli.Util.git_repo_from_cwd
      "circli"

  """
  def git_repo_from_cwd do
    {:ok, dir} = File.cwd()

    dir
    |> String.split("/")
    |> Enum.reverse
    |> Enum.at(0)
  end

  @doc """
  Prints the base directory of the current git repo.
  """
  def git_config_dir do
    {repo_dir, 0} = System.cmd("git", ["rev-parse", "--absolute-git-dir"])
    String.trim(repo_dir)
  end

  @doc """
  Returns the organization and repo names for the current git repo.
  The result is returned as a tuple with the first element being the organization,
  and the second being the repo name.

      iex> Circli.Util.git_repo_info
      {"mcgaffin", "circli"}
  """
  def git_repo_info do
    {:ok, info} = "#{git_config_dir()}/config"
    |> File.open([:read], fn f ->
      IO.read(f, :all)
      |> String.split("\n")
      |> Enum.reduce_while("", fn line, acc ->
        if(String.match?(line, ~r/\[remote "origin"\]/),
          do: { :cont, :next },
          else: if(acc == :next, do: { :halt, line }, else: { :cont, "" }))
      end)
    end)

    [ _, org, repo ] = Regex.run(~r/url.+:(\w+)\/(\w+).git/, info)
    { org, repo }
  end
end
