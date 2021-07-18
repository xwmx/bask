#!/usr/bin/env bats

load test_helper

@test "'bask' with no arguments exits with 0 and prints default help." {
  run "${_BASK}"

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq  0                                       ]]
  [[ "${output}" =~   Usage:${_NEWLINE}\ \ bask\ \<command\>  ]]
}
