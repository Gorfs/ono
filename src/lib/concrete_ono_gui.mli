val row : int ref
val column : int ref

val gui_newline : unit -> (unit, Owi.Result.err) Result.t
val gui_clear_screen : unit -> (unit, Owi.Result.err) Result.t
val gui_print_cell : Kdo.Concrete.I32.t -> (unit, Owi.Result.err) Result.t

val get_gui_functions :
  unit -> (string * Kdo.Concrete.Extern_func.extern_func) list
