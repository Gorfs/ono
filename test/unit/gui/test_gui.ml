let () = Random.self_init ()

let reset () =
  Ono.Concrete_ono_gui.row := 1;
  Ono.Concrete_ono_gui.column := 1

let row () = !(Ono.Concrete_ono_gui.row)
let col () = !(Ono.Concrete_ono_gui.column)




let test_newline_increments_row () =  
  reset ();
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check int) "row incremented" 2 (row ())

let test_newline_resets_column () =
  reset ();
  Ono.Concrete_ono_gui.column := 5;
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check int) "column reset to 1" 1 (col ())

let test_newline_multiple () =
  reset ();
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check int) "row after 3 newlines" 4 (row ())

let test_newline_returns_ok () =
  reset ();
  let result = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check bool) "returns Ok" true (Result.is_ok result)

let test_newline_column_stays_1_after_multiple () =
  reset ();
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check int) "column still 1 after 2 newlines" 1 (col ())

let test_newline_from_arbitrary_row () =
  reset ();
  Ono.Concrete_ono_gui.row := 42;
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check int) "row incremented from 42" 43 (row ())

let test_newline_100_times () =
  reset ();
  for _ = 1 to 100 do
    let _ = Ono.Concrete_ono_gui.gui_newline () in ()
  done;
  Alcotest.(check int) "row after 100 newlines" 101 (row ())

let test_newline_resets_large_column () =
  reset ();
  Ono.Concrete_ono_gui.column := 69;
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check int) "column reset from 69" 1 (col ());
  Alcotest.(check int) "row incremented" 2 (row ())

let test_newline_alternating_state () =
  reset ();
  Ono.Concrete_ono_gui.row := 5;
  Ono.Concrete_ono_gui.column := 10;
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Alcotest.(check int) "row from 5" 6 (row ());
  Alcotest.(check int) "column reset from 10" 1 (col ())



(* tests état initiaux*)

let test_initial_row () =
  reset ();
  Alcotest.(check int) "initial row is 1" 1 (row ())

let test_initial_column () =
  reset ();
  Alcotest.(check int) "initial column is 1" 1 (col ())

let test_double_reset () =
  Ono.Concrete_ono_gui.row := 99;
  Ono.Concrete_ono_gui.column := 99;
  reset ();
  reset ();
  Alcotest.(check int) "row after double reset" 1 (row ());
  Alcotest.(check int) "column after double reset" 1 (col ())

let test_reset_after_operations () =
  reset ();
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  let _ = Ono.Concrete_ono_gui.gui_newline () in
  Ono.Concrete_ono_gui.column := 15;
  reset ();
  Alcotest.(check int) "row reset after ops" 1 (row ());
  Alcotest.(check int) "column reset after ops" 1 (col ())


  



let test_row_column_independent_row () =
  reset ();
  Ono.Concrete_ono_gui.row := 10;
  Alcotest.(check int) "column not affected by row change" 1 (col ())

let test_row_column_independent_column () =
  reset ();
  Ono.Concrete_ono_gui.column := 10;
  Alcotest.(check int) "row not affected by column change" 1 (row ())



let () =
  Alcotest.run "Concrete_ono_gui"
    [
      ( "gui_newline",
        [
          Alcotest.test_case "increments row" `Quick test_newline_increments_row;
          Alcotest.test_case "resets column" `Quick test_newline_resets_column;
          Alcotest.test_case "multiple newlines" `Quick test_newline_multiple;
          Alcotest.test_case "returns Ok" `Quick test_newline_returns_ok;
          Alcotest.test_case "column stays 1 after multiple" `Quick
            test_newline_column_stays_1_after_multiple;
          Alcotest.test_case "from arbitrary row" `Quick
            test_newline_from_arbitrary_row;
          Alcotest.test_case "100 times" `Quick test_newline_100_times;
          Alcotest.test_case "resets large column" `Quick
            test_newline_resets_large_column;
          Alcotest.test_case "alternating state" `Quick
            test_newline_alternating_state;
        ] );
      ( "initial_state",
        [
          Alcotest.test_case "initial row" `Quick test_initial_row;
          Alcotest.test_case "initial column" `Quick test_initial_column;
          Alcotest.test_case "double reset" `Quick test_double_reset;
          Alcotest.test_case "reset after operations" `Quick
            test_reset_after_operations;
        ] );
      ( "independence",
        [
          Alcotest.test_case "row change doesn't affect column" `Quick
            test_row_column_independent_row;
          Alcotest.test_case "column change doesn't affect row" `Quick
            test_row_column_independent_column;
        ] );
    ]
