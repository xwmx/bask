#!/usr/bin/env bats

load test_helper

@test "'bask commands' exits with 0 and prints subcommands." {
  run "${_BASK}" commands

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq  0                                       ]]

  diff                            \
    <(printf "%s\\n" "${output}") \
    <(cat <<HEREDOC
Available commands:
  commands
  help
  push
  subcommands
  tasks
  new
  version
HEREDOC
)
}

@test "'bask subcommands' exits with 0 and prints subcommands." {
  run "${_BASK}" subcommands

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq  0                                       ]]

  diff                            \
    <(printf "%s\\n" "${output}") \
    <(cat <<HEREDOC
Available commands:
  commands
  help
  push
  subcommands
  tasks
  new
  version
HEREDOC
)
}

@test "'bask tasks' exits with 0 and prints subcommands." {
  run "${_BASK}" tasks

  printf "\${status}: '%s'\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"

  [[ "${status}" -eq  0                                       ]]

  diff                            \
    <(printf "%s\\n" "${output}") \
    <(cat <<HEREDOC
Available commands:
  commands
  help
  push
  subcommands
  tasks
  new
  version
HEREDOC
)
}
