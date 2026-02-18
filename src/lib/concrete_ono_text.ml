let text_print_i32 (n : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let text_print_i64 (n : Kdo.Concrete.I64.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let text_read_int () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  Printf.printf "Please enter an integer: ";
  try
    let n = read_int () in
    Ok (Kdo.Concrete.I32.of_int n)
  with
  | Failure msg ->
      Logs.err (fun m ->
          m
            "Failed to read int from stdin (Failure: %s); returning 0 as \
             fallback."
            msg);
      Ok (Kdo.Concrete.I32.of_int32 0l)
  | End_of_file ->
      Logs.err (fun m ->
          m "End_of_file while reading int from stdin; returning 0 as fallback.");
      Ok (Kdo.Concrete.I32.of_int32 0l)

let textSet =
  let open Concrete_ono_types in
  {
    print_i32 = text_print_i32;
    print_i64 = text_print_i64;
    read_int = text_read_int;
  }

let functions =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  [
    ("print_i32", Extern_func (i32 ^->. unit, textSet.print_i32));
    ("print_i64", Extern_func (i64 ^->. unit, textSet.print_i64));
    ("read_int", Extern_func (unit ^->. i32, textSet.read_int));
  ]
