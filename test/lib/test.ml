let () =
  Logs.set_level (Some Logs.App);
  Logs.set_reporter (Logs_fmt.reporter ());
  let tests = Read_int_test.tests in
  QCheck_runner.run_tests_main tests
