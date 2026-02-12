(** Raylib-based GUI for the Game of Life. *)

(* ── State ────────────────────────────────────────────────────────────── *)

(** Current column index (in cells) while buffering a row. *)
let col = ref 0

(** Current row index (in cells) while buffering a frame. *)
let row = ref 0

(** Pixel size of a single cell. *)
let cell_sz = ref 10

(** Grid width in cells. *)
let grid_w = ref 0

(** Grid height in cells. *)
let grid_h = ref 0

(** Whether the window has been initialised. *)
let initialised = ref false

(** Buffer of (col, row, alive) triples for the current frame. *)
let frame_buf : (int * int * bool) list ref = ref []

(** Last rendered frame — kept so we can redraw it in idle loops. *)
let last_frame : (int * int * bool) list ref = ref []

(* ── Internal helpers ─────────────────────────────────────────────────── *)

(** Draw the given cell list onto the current raylib frame. *)
let draw_cells cells =
  let sz = !cell_sz in
  List.iter
    (fun (c, r, alive) ->
      let color =
        if alive then Raylib.Color.orange else Raylib.Color.darkgray
      in
      Raylib.draw_rectangle (c * sz) (r * sz) sz sz color)
    cells

(** Redraw the last rendered frame (used by [sleep] and [wait_for_close]). *)
let redraw_last_frame () =
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.white;
  draw_cells !last_frame;
  Raylib.end_drawing ()

(* ── Public API ───────────────────────────────────────────────────────── *)

let init ~width ~height ~cell_size =
  grid_w := width;
  grid_h := height;
  cell_sz := cell_size;
  let win_w = width * cell_size in
  let win_h = height * cell_size in
  Raylib.init_window win_w win_h "Ono – Game of Life";
  Raylib.set_target_fps 30;
  initialised := true

let print_cell (alive_int : int) =
  if not !initialised then init ~width:90 ~height:50 ~cell_size:10;
  let alive = alive_int <> 0 in
  Printf.eprintf "[gui] print_cell col=%d row=%d alive=%b\n%!" !col !row alive;
  frame_buf := (!col, !row, alive) :: !frame_buf;
  col := !col + 1

let newline () =
  col := 0;
  row := !row + 1

let clear_screen () =
  Printf.eprintf "[gui] clear_screen: %d cells, cell_sz=%d\n%!"
    (List.length !frame_buf) !cell_sz;
  (* Snapshot the buffer so idle loops can redraw it. *)
  last_frame := !frame_buf;
  (* Render the frame. *)
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.white;
  (* Debug: hardcoded red rectangle to verify drawing works *)
  Raylib.draw_rectangle 50 50 200 100 Raylib.Color.red;
  draw_cells !frame_buf;
  Raylib.end_drawing ();
  (* Reset for next frame. *)
  frame_buf := [];
  col := 0;
  row := 0

let sleep seconds =
  let start = Unix.gettimeofday () in
  while
    Unix.gettimeofday () -. start < seconds
    && not (Raylib.window_should_close ())
  do
    redraw_last_frame ()
  done

let should_close () = Raylib.window_should_close ()

let wait_for_close () =
  while not (Raylib.window_should_close ()) do
    redraw_last_frame ()
  done;
  Raylib.close_window ()
