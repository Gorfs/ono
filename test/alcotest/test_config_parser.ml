(* Unit tests for src/lib/config_parser.ml *)

let write_temp_file content =
  let path = Filename.temp_file "ono_test_" ".grid" in
  let oc = open_out path in
  Fun.protect
    ~finally:(fun () -> close_out_noerr oc)
    (fun () -> output_string oc content);
  path

let cleanup path = try Sys.remove path with Sys_error _ -> ()

let with_temp_file content f =
  let path = write_temp_file content in
  Fun.protect ~finally:(fun () -> cleanup path) (fun () -> f path)

let test_load_valid_simple_grid () =
  with_temp_file "@.\n.@" (fun path ->
      let grid = Ono.Config_parser.load_file path in
      Alcotest.(check int) "row count" 2 (Array.length grid);
      Alcotest.(check int) "column count" 2 (Array.length grid.(0));
      Alcotest.(check int) "(0,0) is alive" 1 grid.(0).(0);
      Alcotest.(check int) "(0,1) is dead" 0 grid.(0).(1);
      Alcotest.(check int) "(1,0) is dead" 0 grid.(1).(0);
      Alcotest.(check int) "(1,1) is alive" 1 grid.(1).(1))

let test_load_at_maps_to_one () =
  with_temp_file "@@@" (fun path ->
      let grid = Ono.Config_parser.load_file path in
      Alcotest.(check int) "all cells alive" 1 grid.(0).(0);
      Alcotest.(check int) "all cells alive" 1 grid.(0).(1);
      Alcotest.(check int) "all cells alive" 1 grid.(0).(2))

let test_load_dot_maps_to_zero () =
  with_temp_file "..." (fun path ->
      let grid = Ono.Config_parser.load_file path in
      Alcotest.(check int) "all cells dead" 0 grid.(0).(0);
      Alcotest.(check int) "all cells dead" 0 grid.(0).(1);
      Alcotest.(check int) "all cells dead" 0 grid.(0).(2))

let test_load_larger_grid_dimensions () =
  with_temp_file "@.@.@\n.....\n@.@.@" (fun path ->
      let grid = Ono.Config_parser.load_file path in
      Alcotest.(check int) "3 rows" 3 (Array.length grid);
      Alcotest.(check int) "5 columns" 5 (Array.length grid.(0));
      Alcotest.(check int) "5 columns row 1" 5 (Array.length grid.(1));
      Alcotest.(check int) "5 columns row 2" 5 (Array.length grid.(2)))

let test_load_empty_file_fails () =
  with_temp_file "" (fun path ->
      Alcotest.check_raises "empty file raises Failure"
        (Failure "Empty grid file") (fun () ->
          ignore (Ono.Config_parser.load_file path)))

let test_load_unequal_lines_fails () =
  with_temp_file "@.@\n@.\n@.@" (fun path ->
      Alcotest.check_raises "unequal line lengths raises Failure"
        (Failure "Lines must have same length") (fun () ->
          ignore (Ono.Config_parser.load_file path)))

let test_load_invalid_character_fails () =
  with_temp_file "@.X\n@.@" (fun path ->
      Alcotest.check_raises "invalid character raises Failure"
        (Failure "Invalid character") (fun () ->
          ignore (Ono.Config_parser.load_file path)))

let test_load_single_cell_alive () =
  with_temp_file "@" (fun path ->
      let grid = Ono.Config_parser.load_file path in
      Alcotest.(check int) "1 row" 1 (Array.length grid);
      Alcotest.(check int) "1 column" 1 (Array.length grid.(0));
      Alcotest.(check int) "single alive cell" 1 grid.(0).(0))

let test_load_single_cell_dead () =
  with_temp_file "." (fun path ->
      let grid = Ono.Config_parser.load_file path in
      Alcotest.(check int) "1 row" 1 (Array.length grid);
      Alcotest.(check int) "single dead cell" 0 grid.(0).(0))

let suite =
  [
    ( "Config_parser.load_file",
      [
        Alcotest.test_case "valid 2x2 grid" `Quick test_load_valid_simple_grid;
        Alcotest.test_case "@ maps to 1" `Quick test_load_at_maps_to_one;
        Alcotest.test_case ". maps to 0" `Quick test_load_dot_maps_to_zero;
        Alcotest.test_case "3x5 grid dimensions" `Quick
          test_load_larger_grid_dimensions;
        Alcotest.test_case "single alive cell" `Quick
          test_load_single_cell_alive;
        Alcotest.test_case "single dead cell" `Quick test_load_single_cell_dead;
        Alcotest.test_case "empty file fails" `Quick test_load_empty_file_fails;
        Alcotest.test_case "unequal line lengths fails" `Quick
          test_load_unequal_lines_fails;
        Alcotest.test_case "invalid character fails" `Quick
          test_load_invalid_character_fails;
      ] );
  ]
