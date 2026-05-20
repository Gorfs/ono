type input_event = Typing of string | Confirm | Quit

module State = struct
  type t = {
    mutable row : int;
    mutable column : int;
    mutable in_drawing : bool;
    mutable drawn_cells : (int * int * string) list;
  }

  let create () = { row = 1; column = 1; in_drawing = false; drawn_cells = [] }

  let newline s =
    s.column <- 1;
    s.row <- s.row + 1

  let in_drawing s = s.in_drawing

  let clear s ~in_drawing =
    s.row <- 1;
    s.column <- 1;
    s.in_drawing <- in_drawing;
    s.drawn_cells <- []

  let incr_column s = s.column <- s.column + 1
  let end_drawing s = s.in_drawing <- false

  let add_cell s str ~width =
    s.drawn_cells <- (s.column * width, s.row * width, str) :: s.drawn_cells

  let get_drawn_cells s = s.drawn_cells
  let get_column s = s.column
  let get_row s = s.row
end

let char_width = 30
let state = State.create ()

let gui_newline () =
  State.newline state;
  Ok ()

let gui_print_i32 (n : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Logs.app (fun m -> m "%a" Kdo.Concrete.I32.pp n);
  Ok ()

let gui_clear_screen () =
  if State.in_drawing state then Raylib.end_drawing ();
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.raywhite;
  State.clear state ~in_drawing:true;
  Ok ()

let draw_int_input_modal buf =
  Raylib.draw_rectangle 100 100 400 200 Raylib.Color.darkgray;
  Raylib.draw_text "Enter integer:" 120 130 20 Raylib.Color.white;
  Raylib.draw_text buf 120 170 20 Raylib.Color.yellow

let draw_scene () =
  List.iter
    (fun (x, y, str) -> Raylib.draw_text str x y 40 Raylib.Color.gray)
    (List.rev (State.get_drawn_cells state))

let append_pressed_chars buf =
  let rec loop buf =
    let pressed = Raylib.get_char_pressed () in
    if Uchar.to_int pressed = 0 then buf
    else
      let code = Uchar.to_int pressed in
      if code <= 0x7f then loop (buf ^ String.make 1 (Char.chr code))
      else loop buf
  in
  loop buf

let parse_int buf =
  Option.value (int_of_string_opt (String.trim buf)) ~default:0
  |> Kdo.Concrete.I32.of_int

let handle_backspace buf =
  if Raylib.is_key_pressed Raylib.Key.Backspace && String.length buf > 0 then
    String.sub buf 0 (String.length buf - 1)
  else buf

let draw_frame f =
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.raywhite;
  f ();
  Raylib.end_drawing ();
  State.end_drawing state

let poll_event buf =
  let buf = buf |> append_pressed_chars |> handle_backspace in
  if Raylib.window_should_close () then Quit
  else if
    Raylib.is_key_pressed Raylib.Key.Enter
    || Raylib.is_key_pressed Raylib.Key.Kp_enter
  then Confirm
  else Typing buf

let gui_read_int () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  let rec loop buf =
    draw_frame (fun () ->
        draw_scene ();
        draw_int_input_modal buf);
    match poll_event buf with
    | Quit -> Ok (parse_int "")
    | Confirm -> Ok (parse_int buf)
    | Typing buf -> loop buf
  in
  let result = loop "" in
  draw_frame draw_scene;
  result

let gui_print_cell (cell : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t
    =
  let str = if cell = Kdo.Concrete.I32.zero then "·" else "@" in
  State.add_cell state str ~width:char_width;
  begin
    Raylib.draw_text str
      (State.get_column state * char_width)
      (State.get_row state * char_width)
      40 Raylib.Color.gray;
    State.incr_column state
  end;
  Ok ()

let get_gui_functions () =
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  begin
    Raylib.init_window 2120 1080 "Ono GUI";
    Raylib.set_trace_log_level Raylib.TraceLogLevel.Error;
    State.clear state ~in_drawing:false;
    [
      ("print_i32", Extern_func (i32 ^->. unit, gui_print_i32));
      ("newline", Extern_func (unit ^->. unit, gui_newline));
      ("clear_screen", Extern_func (unit ^->. unit, gui_clear_screen));
      ("read_int", Extern_func (unit ^->. i32, gui_read_int));
      ("print_cell", Extern_func (i32 ^->. unit, gui_print_cell));
    ]
  end
