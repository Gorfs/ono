(** Raylib-based graphical back-end for the concrete ono runtime.

    Initialises a window on first use and exposes the same five extern functions
    as the text back-end ([print_i32], [newline], [clear_screen], [read_int],
    [print_cell]) but rendering through Raylib. *)

val get_gui_functions :
  unit -> (string * Kdo.Concrete.Extern_func.extern_func) list
(** Open the GUI window and return the list of (name, extern_func) bindings for
    the GUI back-end. Calling this has the side effect of creating the Raylib
    window. *)
