let text_print_i32 (n : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let text_print_i64 (n : Kdo.Concrete.I64.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let text_read_int () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  Printf.printf "Please enter an integer: ";
  flush stdout;
  match read_int_opt () with
  | Some n -> Ok (Kdo.Concrete.I32.of_int n)
  | None -> Error (`Msg "Failed to parse integer from stdin")

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
