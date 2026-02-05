type extern_func = Kdo.Concrete.Extern_func.extern_func

type instructionSet = {
  print_i32 : Kdo.Concrete.I32.t -> (unit, Owi.Result.err) Result.t;
  print_i64 : Kdo.Concrete.I64.t -> (unit, Owi.Result.err) Result.t;
  random_i32 : unit -> (Kdo.Concrete.I32.t, Owi.Result.err) Result.t;
}

let text_print_i32 (n : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let text_print_i64 (n : Kdo.Concrete.I64.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let text_random_i32 () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  let n = Random.int32 Int32.max_int in
  Ok (Kdo.Concrete.I32.of_int32 n)

let textSet =
  {
    print_i32 = text_print_i32;
    print_i64 = text_print_i64;
    random_i32 = text_random_i32;
  }

let gui_print_i32 (n : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let gui_print_i64 (n : Kdo.Concrete.I64.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let gui_random_i32 () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  let n = Random.int32 Int32.max_int in
  Ok (Kdo.Concrete.I32.of_int32 n)

let guiSet =
  {
    print_i32 = gui_print_i32;
    print_i64 = gui_print_i64;
    random_i32 = gui_random_i32;
  }

let text_read_int () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  try
    let n = read_int () in
    Ok (Kdo.Concrete.I32.of_int n)
  with Failure _ -> Error (Owi.Result.Err "Failed to read an integer")

let m (use_graphical_window : bool) =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let textSet = textSet in
  let guiSet = guiSet in
  let functions =
    if use_graphical_window then
      [
        ("print_i32", Extern_func (i32 ^->. unit, guiSet.print_i32));
        ("print_i64", Extern_func (i64 ^->. unit, guiSet.print_i64));
        ("random_i32", Extern_func (unit ^->. i32, guiSet.random_i32));
      ]
    else
      [
        ("print_i32", Extern_func (i32 ^->. unit, textSet.print_i32));
        ("print_i64", Extern_func (i64 ^->. unit, textSet.print_i64));
        ("random_i32", Extern_func (unit ^->. i32, textSet.random_i32));
      ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
