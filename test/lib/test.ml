open Ono
open QCheck

let read_int_fixture =
  Filename.concat
    (Filename.dirname Sys.executable_name)
    "../cram/concrete/read_int.t/readint.wat"

let with_stdin_from_string (content : string) (f : unit -> 'a) : 'a =
  let input_file = Filename.temp_file "ono-stdin" ".txt" in
  Out_channel.with_open_text input_file (fun oc -> output_string oc content);
  let saved_stdin = Unix.dup Unix.stdin in
  let fd = Unix.openfile input_file [ Unix.O_RDONLY ] 0 in
  Unix.dup2 fd Unix.stdin;
  Unix.close fd;
  Fun.protect
    ~finally:(fun () ->
      Unix.dup2 saved_stdin Unix.stdin;
      Unix.close saved_stdin;
      Sys.remove input_file)
    f

let run_concrete_read_int_with_input input =
  with_stdin_from_string input (fun () ->
      Concrete_driver.run ~source_file:(Fpath.v read_int_fixture) false 5 5)

let test_read_int_fallbacks_on_eof =
  Test.make ~count:1 ~name:"read_int falls back to 0 on eof" unit (fun () ->
      match run_concrete_read_int_with_input "" with
      | Ok () -> true
      | Error _ -> false)

let is_decimal_int_string s =
  let s1 = int_of_string_opt s in
  match s1 with None -> false | _ -> true

let () =
  let suite =
    [
      Test.make ~count:100 ~name:"read_int accepts valid integer input"
        (make ~print:string_of_int Gen.int) (fun n ->
          match run_concrete_read_int_with_input (string_of_int n ^ "\n") with
          | Ok () -> true
          | Error _ -> false);
      Test.make ~count:100 ~name:"read_int falls back to invalid integer input"
        (make ~print:Fun.id Gen.string) (fun s ->
          QCheck.assume (not (is_decimal_int_string s));
          match run_concrete_read_int_with_input (s ^ "\n") with
          | Ok () -> true
          | Error _ -> false);
      test_read_int_fallbacks_on_eof;
    ]
  in
  List.iter Test.check_exn suite;
  print_endline "All tests passed."
