
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
let print_buffer = Buffer.create 1024 (* buffer pour stocker les données à afficher*)

(*let sleep (x: Kdo.Concrete.F32.t) : (unit, _) Result.t =
  let seconds = Kdo.Concrete.F32.to_float x in
  Unix.sleepf seconds;
  Ok ()*)

let cell_print (x:Kdo.Concrete.I32.t) :(unit, _) Result.t =
  let cell_alive = x <> Kdo.Concrete.I32.of_int32 0l in (*0l c'est le 0 en i32*)
  Buffer.add_string print_buffer (if cell_alive then "🦊" else " ");
  Ok ()

let newline ():(unit, _) Result.t =
  Buffer.add_char print_buffer '\n';
  Ok ()

let clear_screen ():(unit, _) Result.t =
    print_string (Buffer.contents print_buffer);
    print_string "\027[2J";
    Buffer.clear print_buffer;
    Ok ()

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
        (*("sleep", Extern_func (f32 ^->. unit, sleep));*)
        ("cell_print", Extern_func (i32 ^->. unit, cell_print));
        ("newline", Extern_func (unit ^->. unit, newline));
        ("clear_screen", Extern_func (unit ^->. unit, clear_screen));
      ]
    else
      [
        ("print_i32", Extern_func (i32 ^->. unit, textSet.print_i32));
        ("print_i64", Extern_func (i64 ^->. unit, textSet.print_i64));
        ("random_i32", Extern_func (unit ^->. i32, textSet.random_i32));
        (*("sleep", Extern_func (f32 ^->. unit, sleep));*)
        ("cell_print", Extern_func (i32 ^->. unit, cell_print));
        ("newline", Extern_func (unit ^->. unit, newline));
        ("clear_screen", Extern_func (unit ^->. unit, clear_screen));
      ]
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }

