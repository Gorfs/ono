(** The [ono concrete] subcommand: runs a WAT module under concrete execution.
*)

val cmd : Ono_cli.outcome Cmdliner.Cmd.t
(** Cmdliner command definition wired into {!Ono_main}. *)

val normalize_option_int : int option -> int
val normalize_option_bool : bool option -> bool
val normalize_option_fpath : Fpath.t option -> string
val normalize_option_speed : int option -> int
val seed_generator : int option -> unit
