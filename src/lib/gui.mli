(** Raylib-based GUI for the Game of Life.

    This module provides a graphical backend that can be used in place of the
    text-based terminal output. It implements the same abstract operations
    ([print_cell], [newline], [clear_screen], [sleep]) expected by the Wasm Game
    of Life program, but renders cells as colored rectangles in a raylib window.
*)

val init : width:int -> height:int -> cell_size:int -> unit
(** [init ~width ~height ~cell_size] initialises the raylib window. [width] and
    [height] are the grid dimensions (in cells). [cell_size] is the pixel size
    of each cell. *)

val print_cell : int -> unit
(** [print_cell alive] appends a cell to the current row. A non-zero value is
    considered alive. *)

val newline : unit -> unit
(** [newline ()] moves the cursor to the beginning of the next row. *)

val clear_screen : unit -> unit
(** [clear_screen ()] renders the buffered frame to the window and resets the
    cursor to the top-left corner for the next frame. *)

val sleep : float -> unit
(** [sleep seconds] pauses execution for the given duration in seconds. *)

val should_close : unit -> bool
(** [should_close ()] returns [true] when the user has requested that the window
    be closed. *)

val wait_for_close : unit -> unit
(** [wait_for_close ()] blocks until the user closes the window, keeping the
    raylib event loop alive. Closes the window on exit. *)
