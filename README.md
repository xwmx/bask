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

To generate a new "`bask` extension script", meaning a script that
inherits the `bask` foundation, use the following command:

    bask init <script name>

This generates a script that sources the `bask` command. You can add
bash functions in this script and they will be automatically set as
sub-commands available as arguments to the program. Additionally, you
can easily document the programs using the built-in `desc` function. The
help / usage / description information set here is available in the via
the built-in `help` command.

### Commands

Example command group structure:

    desc example ""  # Optional. A short description for the command.
    example() { : }  # The command called by the user.

For usage formatting conventions see:
- http://docopt.org/
- http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html

#### Micro Example

    desc micro <<EOM
    Usage: $_me micro
    EOM
    micro() {
      echo "Hello, World!"
    }

#### Simple Example

    desc simple <<EOM
    Usage:
      $_me simple [<name>]

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

#### Complex Example

    desc complex <<EOM
    Usage:
      $_me complex [<name>] [--farewell]

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
