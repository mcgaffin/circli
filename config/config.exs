# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

import_config "#{Mix.env()}.secret.exs"

config :circli,
  circle1_projects: ["templater", "hedwig"],
  circle2_projects: ["lello"],

  circle2_api_url: "https://circle2.bubtools.net/api/v1.1/project/github",
  circle_api_url: "https://circle.bubtools.net/api/v1.1/project/github"
