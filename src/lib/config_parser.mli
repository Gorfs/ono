(** Initial configuration parser.

    Reads a plain-text grid file where ['@'] marks a live cell and ['.'] a
    dead one, and returns it as a 2D integer array (1 for live, 0 for dead). *)

val load_file : string -> int array array
(** [load_file path] loads the grid at [path].

    Raises [Failure] if the file is empty, contains rows of unequal length,
    or a character other than ['@'] / ['.']. *)
