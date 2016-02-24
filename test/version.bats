#!/usr/bin/env bats

load test_helper

@test "\`bask version\` returns with 0 status." {
  run "${_BASK}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`bask version\` prints a version number." {
  run "${_BASK}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '\d\+\.\d\+\.\d\+'
}

@test "\`bask --version\` returns with 0 status." {
  run "${_BASK}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`bask --version\` prints a version number." {
  run "${_BASK}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '\d\+\.\d\+\.\d\+'
}
