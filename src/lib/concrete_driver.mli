(** Concrete execution driver for ono.

    Parses a WAT source file, compiles it to Wasm, validates and links it
    against the concrete ono runtime (text or GUI), then interprets it
    concretely. *)

val run :
  source_file:Fpath.t ->
  bool ->
  int ->
  int ->
  string ->
  int ->
  (unit, Owi.Result.err) result
(** [run ~source_file use_graphical_window steps display_last config_file speed]
    runs the WAT module located at [source_file].

    - [use_graphical_window]: when [true], renders output through the Raylib
      GUI; otherwise prints to stdout.
    - [steps]: number of simulation steps exposed to the Wasm module via
      [get_steps].
    - [display_last]: only the last [display_last] configurations are displayed.
    - [config_file]: path to the initial grid configuration, or [""] for an
      empty grid.
    - [speed]: delay between steps, in milliseconds. *)
