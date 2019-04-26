# Circli

## Description
This is a simple cli for getting workflow build information from Circle 2 via
the API. For now, it really only does that. Also, it really only does that with Lello.
It might be nice to be able to retry a build or something like that, but that's not today's news.

See [#Project Notes] for more information about my ideas for this project.

## Installing
```sh
> mix do escript.build, escript.install
```
## Running

```sh
> ./circli <lello-branch-name>
```

## Project Notes
This is a script that will check the status of the latest Circle 2 workflow for the current branch.

For example, if I am working in `lello/dm-education-quiz`. When I push a commit to GitHub, I should be able to run this script and see either a successful result like:
```sh
dm-education-quiz> c2
status: success
```

or a failure, like:
```sh
dm-education-quiz> c2
feature-tests: failed
```

The url for fetching this is:

```http
https://circle2.bubtools.net/api/v1.1/project/github/BookBub/lello/tree/dm-education-quiz
```

You must pass the api-token like so
```http
?circle-token=a598c3e26d9b3bbf0fe1d44a1a045236e2522f77
```

The response is a json array containing the results for each build in the workflow.
```json
[
  {
    ...lots of details...
    outcome: "success",
    all_commit_details: {
      committer_date: ...,
      subject: "rename educationNote to blurb",
      ...
    }
  },
  {},
  ...
]
```

I don’t know why, but the API request returns 30 items for the Lello workflow. However, checking a hello workflow in the UI [shows that there are only 15 builds in the workflow](https://circle2.bubtools.net/workflow-run/e9916f9e-a561-459a-a969-51c84fdb32e5), so for some reason the number of builds are doubled. Dunno why.

Sample output is in Insomnia


## desired output
### quick output
* duration - running | succeeded | failed

### more output
* duration
* running job count
* failed job count

### detailed output
* result of workflow (green/red)
* names of running jobs 
* names of failed jobs
* duration of workflow
