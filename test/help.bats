#!/usr/bin/env bats

load test_helper

_HELP_HEADER="\
                 ___         ___         ___
    _____       /  /\       /  /\       /__/|
   /  /::\     /  /::\     /  /:/_     |  |:|
  /  /:/\:\   /  /:/\:\   /  /:/ /\    |  |:|
 /  /:/~/::\ /  /:/~/::\ /  /:/ /::\ __|  |:|
/__/:/ /:/\:/__/:/ /:/\:/__/:/ /:/\:/__/\_|:|____
\  \:\/:/~/:\  \:\/:/__\  \:\/:/~/:\  \:\/:::::/
 \  \::/ /:/ \  \::/     \  \::/ /:/ \  \::/~~~~
  \  \:\/:/   \  \:\      \__\/ /:/   \  \:\\
   \  \::/     \  \:\       /__/:/     \  \:\\
    \__\/       \__\/       \__\/       \__\/"
export _HELP_HEADER

@test "\`help\` with no arguments exits with status 0." {
  run "$_BASK" help
  [ "$status" -eq 0 ]
}

@test "\`help\` with no arguments prints default help." {
  run "$_BASK" help
  _compare "${_HELP_HEADER}" "$(IFS=$'\n'; echo "${lines[*]:0:11}")"
  [[ $(IFS=$'\n'; echo "${lines[*]:0:11}") == "$_HELP_HEADER" ]]
}

@test "\`bask -h\` prints default help." {
  run "$_BASK" -h
  [[ $(IFS=$'\n'; echo "${lines[*]:0:11}") == "$_HELP_HEADER" ]]
}

@test "\`bask --help\` prints default help." {
  run "$_BASK" --help
  [[ $(IFS=$'\n'; echo "${lines[*]:0:11}") == "$_HELP_HEADER" ]]
}

@test "\`bask help help\` prints \`help\` subcommand usage." {
  run "$_BASK" help help
  _expected="$(
    cat <<HEREDOC
Usage:
  bask help [<command>]

Description:
  Display help information for bask or a specified command.
HEREDOC
  )"
  _compare "${_expected}" "${output}"
  [[ "$output" == "$_expected" ]]
}
