open QCheck

let read_int_fixture =
  Filename.concat
    (Filename.dirname Sys.executable_name)
    "../cram/concrete/read_int.t/readint.wat"

let with_stdin_from_string (content : string) (f : unit -> 'a) : 'a =
  let input_file = Filename.temp_file "ono-stdin" ".txt" in
  let oc = open_out input_file in
  output_string oc content;
  close_out oc;
  let saved_stdin = Unix.dup Unix.stdin in
  Fun.protect
    ~finally:(fun () ->
      Unix.dup2 saved_stdin Unix.stdin;
      Unix.close saved_stdin;
      Sys.remove input_file)
    (fun () ->
      let fd = Unix.openfile input_file [ Unix.O_RDONLY ] 0 in
      Unix.dup2 fd Unix.stdin;
      Unix.close fd;
      f ())

let run_concrete_read_int_with_input input =
  with_stdin_from_string input (fun () ->
      Ono.Concrete_driver.run ~source_file:(Fpath.v read_int_fixture) false 5 5)

let input_does_not_raise input =
  try
    let _ = run_concrete_read_int_with_input input in
    true
  with _ -> false

let prop_read_int_never_crashes_on_random_line_input =
  QCheck.Test.make ~count:40
    ~name:"read_int does not crash on random line input"
    (make ~print:Fun.id Gen.string) (fun s -> input_does_not_raise (s ^ "\n"))

let prop_read_int_never_crashes_on_number =
  QCheck.Test.make ~count:40 ~name:"read_int does not crash on integer input"
    (make ~print:string_of_int Gen.int) (fun n ->
      input_does_not_raise (string_of_int n ^ "\n"))

let tests =
  [
    prop_read_int_never_crashes_on_random_line_input;
    prop_read_int_never_crashes_on_number;
  ]
