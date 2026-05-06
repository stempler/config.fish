# fisher plugin with personal configuration

Install using [fisher](https://github.com/jorgebucaran/fisher):

```
fisher install stempler/config.fish
```

Update using:

```
fisher update stempler/config.fish
```

## Local testing

To test a local checkout without pushing, swap the remote install for the local one:

```fish
fisher remove stempler/config.fish
fisher install (pwd)
```

To update when making changes:

```fish
fisher update (pwd)
```

To restore the remote install:

```fish
fisher remove (pwd)
fisher install stempler/config.fish
```

## Features

### mise environment indicator

The active mise environment is shown in the right prompt whenever an environment-specific config is loaded — whether activated via `MISE_ENV`, a project-level `[settings] env = [...]`, or a `.miserc.toml` file:

```
mise:ci
```

### `mise-env` — environment selector

| Command | Effect |
|---|---|
| `mise-env` | Interactive picker (fzf / numbered fallback) |
| `mise-env <name>` | Set `MISE_ENV=<name>` for this shell |
| `mise-env none` | Clear `MISE_ENV` for this shell |
| `mise-env --list` | Print envs available to switch to (script-friendly) |
| `mise-env --show` | Print the currently active env(s) as reported by mise |

`--list` scans for `mise.<env>.toml` / `.mise.<env>.toml` files from the current directory up to the nearest `.git` root (excluding the always-loaded `mise.local.toml`), plus `~/.config/mise/config.<env>.toml`. `--show` asks mise directly which envs are currently active.
