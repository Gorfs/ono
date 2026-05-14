(** Concrete ono runtime module.

    Bundles the externs exposed to a Wasm program under concrete execution: grid
    accessors, simulation parameters and the chosen output back-end (text or
    GUI).

    The resulting module is linked against the user program under the name
    ["ono"]. *)

val m :
  bool ->
  int ->
  int ->
  string ->
  int ->
  Owi.Concrete_extern_func.extern_func Owi.Extern.Module.t
(** [m use_graphical_window steps display_last config_file speed] builds the
    extern module to link against a Wasm program.

    - [use_graphical_window]: when [true], output goes through the Raylib GUI;
      otherwise to stdout.
    - [steps]: number of simulation steps exposed via [get_steps].
    - [display_last]: only the last N configurations are displayed.
    - [config_file]: path to the initial grid, or [""] for an empty grid.
    - [speed]: delay between steps, in milliseconds. *)
