let char_width = 30
let row = ref 1
let column = ref 1

let gui_print_i32 (n : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let gui_print_i64 (n : Kdo.Concrete.I64.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I64.pp n);
  Ok ()

let gui_read_int () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  (* TODO: setup un readEntier pour le Gui *)
  Ok (Kdo.Concrete.I32.of_int32 0l)

let gui_sleep (seconds : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Unix.sleepf (float_of_int (Kdo.Concrete.I32.to_int seconds) /. 1000.0);
  Ok ()

let gui_newline () : (unit, Owi.Result.err) Result.t =
  column := 1;
  row := !row + 1;
  Ok ()

let gui_clear_screen () : (unit, Owi.Result.err) Result.t =
  Raylib.end_drawing ();
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.raywhite;
  row := 1;
  column := 1;
  Ok ()

let gui_print_cell (cell : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t
    =
  let str = if cell = Kdo.Concrete.I32.zero then "·" else "@" in
  begin
    Raylib.draw_text str (!column * char_width) (!row * char_width) 40
      Raylib.Color.gray;
    column := !column + 1
  end;
  Ok ()

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
  begin
    Raylib.init_window 2120 1080 "raylib [core] example - basic window";
    [
      ("print_i32", Extern_func (i32 ^->. unit, guiSet.print_i32));
      ("print_i64", Extern_func (i64 ^->. unit, guiSet.print_i64));
      ("read_int", Extern_func (unit ^->. i32, guiSet.read_int));
      ("sleep", Extern_func (i32 ^->. unit, gui_sleep));
      ("newline", Extern_func (unit ^->. unit, gui_newline));
      ("clear_screen", Extern_func (unit ^->. unit, gui_clear_screen));
      ("print_cell", Extern_func (i32 ^->. unit, gui_print_cell));
    ]
  end
