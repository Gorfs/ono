(* Unit tests for src/tool/ *)

(* === Cmd_concrete === *)

let test_normalize_option_int_none () =
  Alcotest.(check int) "None -> 0" 0 (Cmd_concrete.normalize_option_int None)

let test_normalize_option_int_positive () =
  Alcotest.(check int)
    "Some 5 -> 5" 5
    (Cmd_concrete.normalize_option_int (Some 5))

let test_normalize_option_int_negative () =
  Alcotest.(check int)
    "Some (-3) -> 0" 0
    (Cmd_concrete.normalize_option_int (Some (-3)))

let test_normalize_option_int_zero () =
  Alcotest.(check int)
    "Some 0 -> 0" 0
    (Cmd_concrete.normalize_option_int (Some 0))

let test_normalize_option_int_large () =
  Alcotest.(check int)
    "Some 1000 -> 1000" 1000
    (Cmd_concrete.normalize_option_int (Some 1000))

let test_normalize_option_bool_none () =
  Alcotest.(check bool)
    "None -> false" false
    (Cmd_concrete.normalize_option_bool None)

let test_normalize_option_bool_true () =
  Alcotest.(check bool)
    "Some true -> true" true
    (Cmd_concrete.normalize_option_bool (Some true))

let test_normalize_option_bool_false () =
  Alcotest.(check bool)
    "Some false -> false" false
    (Cmd_concrete.normalize_option_bool (Some false))

let test_seed_generator_none () =
  (* Should not raise *)
  Cmd_concrete.seed_generator None;
  Alcotest.(check pass) "seed_generator None doesn't crash" () ()

let test_seed_generator_some () =
  Cmd_concrete.seed_generator (Some 42);
  let a = Random.int 1000 in
  Cmd_concrete.seed_generator (Some 42);
  let b = Random.int 1000 in
  Alcotest.(check int) "deterministic with same seed" a b

(* === Ono_cli === *)

let test_error_to_exit_code_msg () =
  Alcotest.(check int)
    "Msg -> 123" 123
    (Ono_cli.error_to_exit_code (`Msg "some error"))

let test_error_to_exit_code_unreachable () =
  Alcotest.(check int)
    "Unreachable -> 2" 2
    (Ono_cli.error_to_exit_code `Unreachable)

let test_error_to_exit_code_div_by_zero () =
  Alcotest.(check int)
    "Integer_divide_by_zero -> 3" 3
    (Ono_cli.error_to_exit_code `Integer_divide_by_zero)

let test_error_to_exit_code_overflow () =
  Alcotest.(check int)
    "Integer_overflow -> 4" 4
    (Ono_cli.error_to_exit_code `Integer_overflow)

let test_error_to_exit_code_call_stack () =
  Alcotest.(check int)
    "Call_stack_exhausted -> 5" 5
    (Ono_cli.error_to_exit_code `Call_stack_exhausted)

let test_error_to_exit_code_oob () =
  Alcotest.(check int)
    "Out_of_bounds_memory_access -> 6" 6
    (Ono_cli.error_to_exit_code `Out_of_bounds_memory_access)

let test_error_to_exit_code_conversion () =
  Alcotest.(check int)
    "Conversion_to_integer -> 1" 1
    (Ono_cli.error_to_exit_code `Conversion_to_integer)

let test_exit_code_constants () =
  Alcotest.(check int) "err_msg" 123 Ono_cli.err_msg;
  Alcotest.(check int) "err_unreachable" 2 Ono_cli.err_unreachable;
  Alcotest.(check int)
    "err_integer_divide_by_zero" 3 Ono_cli.err_integer_divide_by_zero;
  Alcotest.(check int) "err_integer_overflow" 4 Ono_cli.err_integer_overflow;
  Alcotest.(check int)
    "err_call_stack_exhausted" 5 Ono_cli.err_call_stack_exhausted;
  Alcotest.(check int)
    "err_out_of_bounds_memory_access" 6 Ono_cli.err_out_of_bounds_memory_access;
  Alcotest.(check int)
    "err_conversion_to_integer" 1 Ono_cli.err_conversion_to_integer

(* === Test suite === *)

let suite =
  [
    ( "Cmd_concrete.normalize_option_int",
      [
        Alcotest.test_case "None" `Quick test_normalize_option_int_none;
        Alcotest.test_case "positive" `Quick test_normalize_option_int_positive;
        Alcotest.test_case "negative" `Quick test_normalize_option_int_negative;
        Alcotest.test_case "zero" `Quick test_normalize_option_int_zero;
        Alcotest.test_case "large" `Quick test_normalize_option_int_large;
      ] );
    ( "Cmd_concrete.normalize_option_bool",
      [
        Alcotest.test_case "None" `Quick test_normalize_option_bool_none;
        Alcotest.test_case "true" `Quick test_normalize_option_bool_true;
        Alcotest.test_case "false" `Quick test_normalize_option_bool_false;
      ] );
    ( "Cmd_concrete.seed_generator",
      [
        Alcotest.test_case "None" `Quick test_seed_generator_none;
        Alcotest.test_case "deterministic" `Quick test_seed_generator_some;
      ] );
    ( "Ono_cli.error_to_exit_code",
      [
        Alcotest.test_case "Msg" `Quick test_error_to_exit_code_msg;
        Alcotest.test_case "Unreachable" `Quick
          test_error_to_exit_code_unreachable;
        Alcotest.test_case "Integer_divide_by_zero" `Quick
          test_error_to_exit_code_div_by_zero;
        Alcotest.test_case "Integer_overflow" `Quick
          test_error_to_exit_code_overflow;
        Alcotest.test_case "Call_stack_exhausted" `Quick
          test_error_to_exit_code_call_stack;
        Alcotest.test_case "Out_of_bounds_memory_access" `Quick
          test_error_to_exit_code_oob;
        Alcotest.test_case "Conversion_to_integer" `Quick
          test_error_to_exit_code_conversion;
      ] );
    ( "Ono_cli.exit_code_constants",
      [ Alcotest.test_case "values" `Quick test_exit_code_constants ] );
  ]
