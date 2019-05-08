defmodule Circli.Util do
  def cwd do
    {:ok, dir} = File.cwd()
    dir
  end

  def current_branch do
    {branch_name, 0} = System.cmd("git", ["symbolic-ref", "--short", "HEAD"])
    String.trim_trailing(branch_name)
  end

  @doc """
  This should find the name of the git repo from the current directory. This occurs 
  by looking for a directory named `.git`. If that is found, then the current directory is
  determined to be the base of a git repo.

  If not, then we check the parent, then its parent, until we find a git repo or run out of directories.

      iex> Circli.Util.git_repo_from_cwd
      "circli"

  """
  def git_repo_from_cwd do
    dir = cwd()

    dir
    |> String.split("/")
    |> Enum.reverse
    |> Enum.at(0)
  end
end
