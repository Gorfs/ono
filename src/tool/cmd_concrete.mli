(** The [ono concrete] subcommand: runs a WAT module under concrete execution.
*)

val seed_generator : int option -> unit
(** [seed_generator seed] initializes OCaml's random generator with [seed] when
    provided, or with a self-initialized seed otherwise. *)

val normalize_option_int : int option -> int
(** [normalize_option_int value] returns [value] when it is non-negative, and
    the default value [10] otherwise. *)

val normalize_option_bool : bool option -> bool
(** [normalize_option_bool value] returns [value] when present, or [false]. *)

val normalize_option_fpath : Fpath.t option -> string
(** [normalize_option_fpath value] returns the path as a string, or [""] when
    absent. *)

val normalize_option_speed : int option -> int
(** [normalize_option_speed value] returns [value] when present, or the default
    delay [1000]. *)

val cmd : Ono_cli.outcome Cmdliner.Cmd.t
(** Cmdliner command definition wired into {!Ono_main}. *)
