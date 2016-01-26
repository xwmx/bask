#!/usr/bin/env bats

load test_helper

@test "\`bask\` with no arguments exits with status 0." {
  run "$_BASK"
  [ "$status" -eq 0 ]
}

@test "\`bask\` with no arguments prints default help." {
  run "$_BASK"
  _expected="\
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
  _compare "${_expected}" "$(IFS=$'\n'; echo "${lines[*]:0:11}")"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:11}")" == "$_expected" ]]
}
