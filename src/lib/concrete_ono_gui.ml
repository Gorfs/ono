let char_width = 30
let row = ref 1
let column = ref 1

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

let get_gui_functions () =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  begin
    Raylib.init_window 2120 1080 "Ono GUI";
    Raylib.set_trace_log_level Raylib.TraceLogLevel.Error;
    [
      ("newline", Extern_func (unit ^->. unit, gui_newline));
      ("clear_screen", Extern_func (unit ^->. unit, gui_clear_screen));
      ("print_cell", Extern_func (i32 ^->. unit, gui_print_cell));
    ]
  end
