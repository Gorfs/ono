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

let start_output_capture output_file =
  let saved_stdout = Unix.dup Unix.stdout in
  let saved_stderr = Unix.dup Unix.stderr in
  let fd = Unix.openfile output_file [ Unix.O_WRONLY; Unix.O_TRUNC ] 0o600 in
  Unix.dup2 fd Unix.stdout;
  Unix.dup2 fd Unix.stderr;
  Unix.close fd;
  (saved_stdout, saved_stderr)

let restore_output_capture (saved_stdout, saved_stderr) =
  Format.pp_print_flush Format.std_formatter ();
  Format.pp_print_flush Format.err_formatter ();
  Unix.dup2 saved_stdout Unix.stdout;
  Unix.dup2 saved_stderr Unix.stderr;
  Unix.close saved_stdout;
  Unix.close saved_stderr

let read_and_remove_file path =
  let input = open_in path in
  let output_length = in_channel_length input in
  let output = really_input_string input output_length in
  close_in_noerr input;
  Sys.remove path;
  output

let with_output_capture (f : unit -> 'a) : 'a * string =
  let output_file = Filename.temp_file "ono-output" ".txt" in
  let saved_output = start_output_capture output_file in
  Fun.protect
    ~finally:(fun () -> restore_output_capture saved_output)
    (fun () ->
      let result = f () in
      let output = read_and_remove_file output_file in
      (result, output))

let run_concrete_read_int_with_input input =
  with_output_capture (fun () ->
      with_stdin_from_string input (fun () ->
          Ono.Concrete_driver.run ~source_file:(Fpath.v read_int_fixture) false
            5 5))

let contains_substring text needle =
  let text_len = String.length text in
  let needle_len = String.length needle in
  let rec loop index =
    if index + needle_len > text_len then false
    else if String.sub text index needle_len = needle then true
    else loop (index + 1)
  in
  needle_len = 0 || loop 0

let input_ok input =
  match run_concrete_read_int_with_input input with
  | Ok (), _ -> true
  | Error _, _ -> false

let output_contains input expected =
  match run_concrete_read_int_with_input input with
  | Ok (), output -> contains_substring output expected
  | Error _, _ -> false

let signed_int_gen =
  let open Gen in
  map
    (fun (is_negative, n) -> if is_negative then -n else n)
    (pair bool (int_bound 100_000))

let invalid_input_gen =
  let open Gen in
  oneof
    [
      map (fun s -> s ^ "x") string;
      map (fun n -> string_of_int n ^ "x") int;
      return "";
    ]

let prop_accepts_valid_integer_input =
  QCheck.Test.make ~count:100 ~name:"read_int accepts valid integer input"
    (make ~print:string_of_int Gen.int) (fun n ->
      input_ok (string_of_int n ^ "\n"))

let prop_accepts_valid_integer_with_whitespace =
  QCheck.Test.make ~count:80
    ~name:"read_int accepts valid integer surrounded by whitespace"
    (make ~print:string_of_int signed_int_gen) (fun n ->
      input_ok ("  \t" ^ string_of_int n ^ "  \n"))

let prop_prints_the_read_integer =
  QCheck.Test.make ~count:80 ~name:"read_int prints the parsed integer"
    (make ~print:string_of_int signed_int_gen) (fun n ->
      output_contains (string_of_int n ^ "\n") (string_of_int n))

let prop_falls_back_on_invalid_integer_input =
  QCheck.Test.make ~count:100
    ~name:"read_int falls back on invalid integer input"
    (make ~print:Fun.id invalid_input_gen) (fun s -> input_ok (s ^ "\n"))

let prop_invalid_input_prints_fallback_zero =
  QCheck.Test.make ~count:80 ~name:"read_int invalid input prints fallback 0"
    (make ~print:Fun.id invalid_input_gen) (fun s ->
      output_contains (s ^ "\n") "0")

let prop_falls_back_on_eof =
  QCheck.Test.make ~count:1 ~name:"read_int falls back on eof" unit (fun () ->
      input_ok "")

let prop_eof_prints_fallback_zero =
  QCheck.Test.make ~count:1 ~name:"read_int eof prints fallback 0" unit
    (fun () -> output_contains "" "0")

let prop_accepts_trailing_input_after_first_integer =
  QCheck.Test.make ~count:80
    ~name:"read_int accepts trailing input after first integer"
    (make ~print:string_of_int signed_int_gen) (fun n ->
      let input = string_of_int n ^ "\n999\n" in
      input_ok input)

let tests =
  [
    prop_accepts_valid_integer_input;
    prop_accepts_valid_integer_with_whitespace;
    prop_prints_the_read_integer;
    prop_falls_back_on_invalid_integer_input;
    prop_invalid_input_prints_fallback_zero;
    prop_falls_back_on_eof;
    prop_eof_prints_fallback_zero;
    prop_accepts_trailing_input_after_first_integer;
  ]
