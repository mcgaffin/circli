# Circli

## Description
This is a simple cli for getting workflow build information from Circle 2 via
the API. For now, it really only does that. Also, it is not currently very configurable, but that is in progress.
It might be nice to be able to retry a build or something like that, but that's not today's news.


## Installing
```sh
# build the script with mix, the Elixir build tool
> mix do escript.build, escript.install

# add mix scripts to your PATH
> echo "export PATH $PATH:$HOME/.mix/escripts" >> ~/.bashrc
```
## Running

```sh
> cd /path/to/lello
> circli [-b <lello-branch-name>]
```
