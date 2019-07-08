# Circli

## Description
This is a simple cli for getting workflow build information from Circle 2 via
the API. For now, it really only does that. Also, it really only does that with Lello.
It might be nice to be able to retry a build or something like that, but that's not today's news.

See [Project Notes](https://github.com/mcgaffin/circli/blob/master/README.md#project-notes) for more information about my ideas for this project.

## Installing
```sh
> mix do escript.build, escript.install
```
## Running

```sh
> ./circli [-b <lello-branch-name>]
```
