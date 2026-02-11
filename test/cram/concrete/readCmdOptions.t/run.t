See if the wasm can see the steps and last_scenes options
  $ dune exec -- ono concrete test.wat --steps 10 --display-last 5
  10
  5
  OK!
Deal with non numbers :
  $ dune exec -- ono concrete test.wat --steps ab
  ono: option '--steps': invalid value 'ab', expected an integer
  Usage: ono concrete [OPTION]… FILE
  Try 'ono concrete --help' or 'ono --help' for more information.
  ono: [ERROR] command line parsing error
  [124]
