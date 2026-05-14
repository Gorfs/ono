(** The [ono concrete] subcommand: runs a WAT module under concrete execution.
*)

val seed_generator : int option -> unit
(** Initializes the pseudo-random generator, either nondeterministically when
    given [None] or deterministically from the provided seed. *)

val normalize_option_int : int option -> int
(** Converts optional integer CLI arguments to their defaulted runtime value. *)

val normalize_option_bool : bool option -> bool
(** Converts optional boolean CLI arguments to their defaulted runtime value. *)

val normalize_option_fpath : Fpath.t option -> string
(** Converts optional path CLI arguments to their runtime string value. *)

val normalize_option_speed : int option -> int
(** Converts optional speed CLI arguments to their defaulted runtime value. *)

val cmd : Ono_cli.outcome Cmdliner.Cmd.t
(** Cmdliner command definition wired into {!Ono_main}. *)
