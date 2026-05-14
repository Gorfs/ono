Run symbolic configuration generation and check that it reaches a satisfying model:
  $ ono symbolic config-generation.wat --no-stop-at-failure 2>&1 | grep "Reached problem"
  ono: [ERROR] owi error: Reached problem!
