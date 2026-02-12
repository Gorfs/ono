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
  frame_buf := (!col, !row, alive) :: !frame_buf;
  col := !col + 1

let newline () =
  col := 0;
  row := !row + 1

let clear_screen () =
  (* Begin a raylib frame. *)
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.black;
  (* Draw every buffered cell. *)
  let sz = !cell_sz in
  List.iter
    (fun (c, r, alive) ->
      let color =
        if alive then Raylib.Color.orange else Raylib.Color.darkgray
      in
      Raylib.draw_rectangle (c * sz) (r * sz) sz sz color)
    !frame_buf;
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
    Raylib.begin_drawing ();
    Raylib.end_drawing ()
  done

let should_close () = Raylib.window_should_close ()

let wait_for_close () =
  while not (Raylib.window_should_close ()) do
    Raylib.begin_drawing ();
    Raylib.end_drawing ()
  done;
  Raylib.close_window ()
