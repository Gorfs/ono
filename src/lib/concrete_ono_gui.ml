let gui_print_i32 (n : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let gui_print_i64 (n : Kdo.Concrete.I64.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let gui_read_int () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  (* TODO: setup un readEntier pour le Gui *)
  Ok (Kdo.Concrete.I32.of_int32 0l)

let guiSet =
  let open Concrete_ono_types in
  {
    print_i32 = gui_print_i32;
    print_i64 = gui_print_i64;
    read_int = gui_read_int;
  }

let functions =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  [
    ("print_i32", Extern_func (i32 ^->. unit, guiSet.print_i32));
    ("print_i64", Extern_func (i64 ^->. unit, guiSet.print_i64));
    ("read_int", Extern_func (unit ^->. i32, guiSet.read_int));
  ]
