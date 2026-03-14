# ghx

Run any repository from source without worrying about the runtime.

`ghx` resolves repositories via [ghq](https://github.com/x-motemen/ghq), detects the project's runtime automatically, and executes the appropriate run command.

## Install

```bash
brew install uraura/ghx/ghx
```

Or manually:

```bash
ghq get uraura/ghx
export PATH="$(ghq root)/github.com/uraura/ghx:$PATH"
```

## Usage

```
ghx <repospec> [args...]
ghx <repospec> -- [entrypoint] [args...]
```

### Examples

```bash
# Go project
ghx hashicorp/terraform version

# Rust project
ghx astral-sh/ruff check --help

# Python project (via uv)
ghx aws/aws-cli --version

# Specify an entrypoint within the repo
ghx cli/cli -- cmd/gh version

# Dry run: show what would be executed
ghx --dryrun hashicorp/terraform plan
# => cd /path/to/hashicorp/terraform && go run ./cmd/terraform plan
```

## How it works

1. Resolves `<repospec>` via `ghq list`. If not found locally, runs `ghq get` to clone it.
2. Detects the runtime by checking for marker files (in priority order):

| File | Runtime | Command |
|------|---------|---------|
| `go.mod` | Go | `go run ./cmd/<name>` or `go run .` |
| `Cargo.toml` | Rust | `cargo run --bin <name>` |
| `pyproject.toml` | Python | `uv run <name>` (auto-detects command from project metadata) |
| `package.json` | Node | `npx <name>` |

3. If no runtime is detected, attempts to directly execute the entrypoint or a file matching the repo basename.
4. `exec`s the final command (replaces the shell process for transparent signal/exit-code handling).

## Options

| Flag | Description |
|------|-------------|
| `--help` | Show help message |
| `--dryrun` | Print the command that would be executed without running it |

## Requirements

- [ghq](https://github.com/x-motemen/ghq)
- bash
- Runtime tools as needed: `go`, `cargo`, `uv`, `npx`
