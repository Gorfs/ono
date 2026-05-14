(** The [ono symbolic] subcommand: explores a WAT module under symbolic
    execution. *)

val cmd : Ono_cli.outcome Cmdliner.Cmd.t
(** Cmdliner command definition wired into {!Ono_main}. *)
