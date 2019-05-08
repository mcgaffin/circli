defmodule Circli.Util do
  def cwd do
    {:ok, dir} = File.cwd()
    dir
  end

  def current_branch do
    {branch_name, 0} = System.cmd("git", ["symbolic-ref", "--short", "HEAD"])
    String.trim_trailing(branch_name)
  end
end
