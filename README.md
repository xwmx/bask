                      ___         ___         ___
         _____       /  /\       /  /\       /__/|
        /  /::\     /  /::\     /  /:/_     |  |:|
       /  /:/\:\   /  /:/\:\   /  /:/ /\    |  |:|
      /  /:/~/::\ /  /:/~/::\ /  /:/ /::\ __|  |:|
     /__/:/ /:/\:/__/:/ /:/\:/__/:/ /:/\:/__/\_|:|____
     \  \:\/:/~/:\  \:\/:/__\\  \:\/:/~/:\  \:\/:::::/
      \  \::/ /:/ \  \::/     \  \::/ /:/ \  \::/~~~~
       \  \:\/:/   \  \:\      \__\/ /:/   \  \:\
        \  \::/     \  \:\       /__/:/     \  \:\
         \__\/       \__\/       \__\/       \__\/

# bask

A mini-framework for command-centric Bash scripts.

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

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

    brew install alphabetum/taps/bask

### bpkg

To install with [bpkg](http://www.bpkg.io/):

    bpkg install alphabetum/bask

### Manual

To install manually, simply add the `bask` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

    curl -L https://raw.github.com/alphabetum/bask/master/bask \
      -o ~/bin/bask && chmod +x ~/bin/bask

## Usage

`bask` can be used primarily in two ways: with with scripts that source (or,
in other words, inherit from) the `bask` program, or with Baskfiles defining
functions for the current context.

### Bask Scripts

To generate a new `bask` script, meaning a script that
inherits the `bask` foundation, use add an argument to the `new`
command specifying the script name:

```bash
bask new <script name>
```

This generates a script that sources the `bask` command. You can add
bash functions in this script and they will be automatically set as
sub-commands available as arguments to the program. Additionally, you
can easily document the programs using the built-in `desc` function. The
help / usage / description information set here is available in the via
the built-in `help` command.

### Baskfiles

A Baskfile is simply a file containing bash functions and optional
descriptions that can be run using the `bask` command directly. This can
be useful for defining task-centric commands within a particular scope
where a full program would be unnecessary.

To generate a new "Baskfile", use `bask new` with no arguments:

```bash
bask new
```

When the `bask` program is run, it first looks in the
current directory for a Baskfile and sources it if one is present. If it
doesn't file a Baskfile in the current directory, it traverses the
parent directories, sourcing the first Baskfile it encounters.

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

#### Example Command Groups

##### Micro Example

```bash
desc micro "Usage: $_ME micro"
micro() {
  echo "Hello, World!"
}
```

##### Simple Example

```bash
desc simple <<HEREDOC
Usage:
  $_ME simple [<name>]

Description:
  Print the greeting, "Hello, World!"
HEREDOC
simple() {
  if [[ -n "${1:-}" ]]
  then
    local name="$1"
  else
    local name="World"
  fi
  printf "Hello, %s!\n" "$name"
}
```

##### Complex Example

```bash
desc complex <<HEREDOC
Usage:
  $_ME complex [<name>] [--farewell]

Options:
  --farewell  Print "Goodbye, World!"

Description:
  Print the greeting, "Hello, World!"
HEREDOC
complex() {
  local greeting="Hello"
  local arguments=()

  for arg in "${_COMMAND_ARGV[@]:-}"
  do
    case $arg in
    --farewell) greeting="Goodbye";;
    -*) _die printf "Unexpected option: %s\n" "$arg";;
    *) arguments+=($arg);;
    esac
  done
  local name=${arguments[1]:-}
  if [[ -n "$name" ]]
  then
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

