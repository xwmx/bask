# bask

An experimental framework for command-centric Bash scripts.

Note: this is a work in progress and everything might change.

## Usage

To generate a new "`bask` extension script, use

    bask init <program name>

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
