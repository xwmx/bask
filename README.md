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

A framework for command-centric Bash scripts.

## Features

Some basic features available automatically:

- Strict Mode,
- Help template, printable with `-h` or `--help`,
- `_debug` printing with `--debug` flag,
- `_exit_1` and `_warn` functions with error message printing,
- Option normalization (eg, `-ab -c` -> `-a -b -c`) and option parsing,
- Automatic arbitrary command loading,
- A simple approach for specifying per-command help with `describe`,
- Built-in commands for help, version, and command listing,
- Conventions for distinguishing between functions and program commands,
- Useful utility functions.

## Installation

### Homebrew

To install with [Homebrew](http://brew.sh/):

```bash
brew tap xwmx/taps
brew install bask
```

### npm

To install with [npm](https://www.npmjs.com/package/bask.sh):

```bash
npm install --global bask.sh
```

### bpkg

To install with [bpkg](http://www.bpkg.io/):

```bash
bpkg install xwmx/bask
```

### Manual

To install manually, simply add the `bask` script to your `$PATH`. If
you already have a `~/bin` directory, you can use the following command:

```bash
curl -L https://raw.github.com/xwmx/bask/master/bask \
  -o ~/bin/bask && chmod +x ~/bin/bask
```

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
can easily document the programs using the built-in `describe` function.
The help / usage / description information set here is available in the
via the built-in `help` command.

### Baskfiles

A `Baskfile` is a file containing bash functions and optional
descriptions that can be run using the `bask` command directly, and can
be defined on a project-by-project basis. This can be useful for defining
task-centric commands within a particular scope where a full program
would be unnecessary.

A `Baskfile` is similar to a [Makefile](https://en.wikipedia.org/wiki/Makefile)
or a [Rakefile](https://en.wikipedia.org/wiki/Rake_(software)) and looks like
this:

```bash
# Baskfile
describe "hello" <<HEREDOC
Usage:
  bask hello

Description:
  Print a greeting.
HEREDOC
hello() {
  echo "Hello from bask!"
}
```

To generate a new `Baskfile`, use `bask new` with no arguments:

```bash
bask new
```

When you run the `bask` program, it first looks in the
current directory for a `Baskfile` and sources it if one is present. If it
doesn't find a `Baskfile` in the current directory, it traverses the
parent directories, sourcing the first `Baskfile` it encounters.

### Commands

Commands in `bask` are simply Bash functions with optional descriptions.
Defined functions will be automatically loaded and displayed as part of
the usage information when the parent command is run. Command-specific
usage information can be set with the `describe` function, and this usage
information will be made automatically available to the parent program's
`help` command.

Example command group structure:

```bash
describe example ""  # Optional. A short description for the command.
example() { : }  # The command called by the user.
```

For usage formatting conventions see:
- http://docopt.org/
- http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html

#### Example Command Groups

##### Micro Example

```bash
describe micro "Usage: $_ME micro"
micro() {
  echo "Hello, World!"
}
```

##### Simple Example

```bash
describe simple <<HEREDOC
Usage:
  $_ME simple [<name>]

Description:
  Print the greeting, "Hello, World!"
HEREDOC
simple() {
  local _name="${1:-World}"

  printf "Hello, %s!\n" "${_name}"
}
```

##### Complex Example

```bash
describe complex <<HEREDOC
Usage:
  $_ME complex [<name>] [--farewell]

Options:
  --farewell  Print "Goodbye, World!"

Description:
  Print the greeting, "Hello, World!"
HEREDOC
complex() {
  local _greeting="Hello"
  local _name="World"

  for __arg in "${@:-}"
  do
    case "${__arg}" in
      --farewell)
        _greeting="Goodbye"
        ;;
      -*)
        _exit_1 printf "Unexpected option: %s\n" "${__arg}"
        ;;
      *)
        if [[ "${_name}" == "World" ]] && [[ -n "${__arg:-}" ]]
        then
          _name="${__arg}"
        fi
        ;;
    esac
  done

  printf "%s, %s!\n" "${_greeting}" "${_name}"
}
```

## Optional Vim Configuration

In order to enable Baskfile syntax highlighting in Vim, add the
following line to your `.vimrc`.

```VimL
autocmd BufRead,BufNewFile Baskfile call SetFileTypeSH("bash")
```

