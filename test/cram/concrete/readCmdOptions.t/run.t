See if the wasm can see the steps and last_scenes options
  $ dune exec -- ono concrete test.wat --steps 10 --display-last 5
  10
  5
  OK!
Deal with non numbers :
  $ dune exec -- ono concrete test.wat --steps ab
  Usage: ono concrete [--help] [OPTION]… FILE
  ono: option --steps: invalid value ab, expected an integer
  ono: [ERROR] command line parsing error
  [124]
