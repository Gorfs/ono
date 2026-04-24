(* Unit tests for src/lib/ (excluding error.ml and syntax.ml) *)

(* === Concrete_ono_text === *)

let test_text_functions_count () =
  Alcotest.(check int)
    "functions list has 3 entries" 3
    (List.length Ono.Concrete_ono_text.functions)

let test_text_functions_names () =
  let names = List.map fst Ono.Concrete_ono_text.functions in
  Alcotest.(check (list string))
    "function names"
    [ "print_i32"; "print_i64"; "read_int" ]
    names

(* === Concrete_ono_module === *)

let test_module_text_mode_function_count () =
  let m = Ono.Concrete_ono_module.m false 0 0 in
  let fns = m.Owi.Extern.Module.functions in
  (* base: random_i32, get_steps, get_display_last, sleep
     + text: print_i32, print_i64, read_int *)
  Alcotest.(check int) "text mode has 7 functions" 7 (List.length fns)

let test_module_text_mode_has_base_functions () =
  let m = Ono.Concrete_ono_module.m false 0 0 in
  let names = List.map fst m.Owi.Extern.Module.functions in
  Alcotest.(check bool) "has random_i32" true (List.mem "random_i32" names);
  Alcotest.(check bool) "has get_steps" true (List.mem "get_steps" names);
  Alcotest.(check bool)
    "has get_display_last" true
    (List.mem "get_display_last" names);
  Alcotest.(check bool) "has sleep" true (List.mem "sleep" names)

let test_module_text_mode_has_text_functions () =
  let m = Ono.Concrete_ono_module.m false 0 0 in
  let names = List.map fst m.Owi.Extern.Module.functions in
  Alcotest.(check bool) "has print_i32" true (List.mem "print_i32" names);
  Alcotest.(check bool) "has print_i64" true (List.mem "print_i64" names);
  Alcotest.(check bool) "has read_int" true (List.mem "read_int" names)

let test_module_text_mode_no_gui_functions () =
  let m = Ono.Concrete_ono_module.m false 0 0 in
  let names = List.map fst m.Owi.Extern.Module.functions in
  Alcotest.(check bool) "no newline" false (List.mem "newline" names);
  Alcotest.(check bool) "no clear_screen" false (List.mem "clear_screen" names);
  Alcotest.(check bool) "no print_cell" false (List.mem "print_cell" names)

(* === Symbolic_ono_module === *)

let test_symbolic_module_function_count () =
  let fns = Ono.Symbolic_ono_module.m.Owi.Extern.Module.functions in
  Alcotest.(check int) "symbolic module has 3 functions" 3 (List.length fns)

let test_symbolic_module_function_names () =
  let names =
    List.map fst Ono.Symbolic_ono_module.m.Owi.Extern.Module.functions
  in
  Alcotest.(check bool) "has print_i32" true (List.mem "print_i32" names);
  Alcotest.(check bool) "has i32_symbol" true (List.mem "i32_symbol" names);
  Alcotest.(check bool) "has read_int" true (List.mem "read_int" names)

(* === Test suite === *)

let suite =
  [
    ( "Concrete_ono_text",
      [
        Alcotest.test_case "functions count" `Quick test_text_functions_count;
        Alcotest.test_case "functions names" `Quick test_text_functions_names;
      ] );
    ( "Concrete_ono_module",
      [
        Alcotest.test_case "text mode function count" `Quick
          test_module_text_mode_function_count;
        Alcotest.test_case "text mode has base functions" `Quick
          test_module_text_mode_has_base_functions;
        Alcotest.test_case "text mode has text functions" `Quick
          test_module_text_mode_has_text_functions;
        Alcotest.test_case "text mode has no GUI functions" `Quick
          test_module_text_mode_no_gui_functions;
      ] );
    ( "Symbolic_ono_module",
      [
        Alcotest.test_case "function count" `Quick
          test_symbolic_module_function_count;
        Alcotest.test_case "function names" `Quick
          test_symbolic_module_function_names;
      ] );
  ]
