# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

import_config "#{Mix.env()}.secret.exs"

config :circli,
  circle1_projects: ["templater", "hedwig"],
  circle2_projects: ["lello"]
