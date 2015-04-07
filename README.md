# bask

An experimental framework for command-centric Bash scripts.

Note: this is a work in progress and everything might change.

## Features

Some basic features available automatically:

- Strict Mode,
- Help template, printable with `-h` or `--help`,
- `debug` printing with `--debug` flag,
- `die` command with error message printing and exiting,
- Option normalization (eg, `-ab -c` -> `-a -b -c`) and option parsing,
- Automatic arbitrary command loading,
- A DSL for specifying per-command help,
- Built-in commands for help, version, and command listing,
- Conventions for distinguishing between functions and program commands,
- Useful utility functions.

## Usage

`bask` can be used primarily in two ways: with Baskfiles defining
functions for the current context, or with extensions scripts that
source (or, in other words, inherit from) the `bask` program.

### Baskfiles

To generate a new "Baskfile", use `bask init` with no arguments:

```bash
bask init
```

A Baskfile is simply a file containing bash functions and optional
descriptions.

When the `bask` program is run, it first looks in the
current directory for a Baskfile and sources it if one is present. If it
doesn't file a Baskfile in the current directory, it traverses the
parent directories, sourcing the first Baskfile it encounters.

### Extension Scripts

To generate a new "`bask` extension script", meaning a script that
inherits the `bask` foundation, use add an argument to the `init`
command specifying the script name:

```bash
bask init <script name>
```

This generates a script that sources the `bask` command. You can add
bash functions in this script and they will be automatically set as
sub-commands available as arguments to the program. Additionally, you
can easily document the programs using the built-in `desc` function. The
help / usage / description information set here is available in the via
the built-in `help` command.

### Commands

Commands in `bask` are simply Bash functions with optional descriptions.
Defined functions will be automatically loaded and displayed as part of
the usage information when the parent command is run. Command-specific
usage information can be set with the `desc` function, and this usage
information will be made automatically available to the parent program's
`help` command.

Example command group structure:

```bash
desc example ""  # Optional. A short description for the command.
example() { : }  # The command called by the user.
```

For usage formatting conventions see:
- http://docopt.org/
- http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html

#### Micro Example

```bash
desc micro <<EOM
Usage: $_ME micro
EOM
micro() {
  echo "Hello, World!"
}
```

#### Simple Example

```bash
desc simple <<EOM
Usage:
  $_ME simple [<name>]

Description:
  Print the greeting, "Hello, World!"
EOM
simple() {
  if [[ -n "${1:-}" ]]; then
    local name="$1"
  else
    local name="World"
  fi
  printf "Hello, %s!\n" "$name"
}
```

#### Complex Example

```bash
desc complex <<EOM
Usage:
  $_ME complex [<name>] [--farewell]

Options:
  --farewell  Print "Goodbye, World!"

Description:
  Print the greeting, "Hello, World!"
EOM
complex() {
  local greeting="Hello"
  local arguments=()

  for arg in "${command_argv[@]:-}"; do
    case $arg in
    --farewell) greeting="Goodbye";;
    -*) _die printf "Unexpected option: %s\n" "$arg";;
    *) arguments+=($arg);;
    esac
  done
  local name=${arguments[1]:-}
  if [[ -n "$name" ]]; then
    printf "%s, %s!\n" "$greeting" "$name"
  else
    printf "%s, World!\n" "$greeting"
  fi
}
```

## Optional Vim Configuration

In order to enable Baskfile syntax highlighting in Vim, add the
following line to your `.vimrc`.

```VimL
autocmd BufRead,BufNewFile Baskfile call SetFileTypeSH("bash")
```
