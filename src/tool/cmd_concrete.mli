(** The [ono concrete] subcommand: runs a WAT module under concrete
    execution. *)

val cmd : Ono_cli.outcome Cmdliner.Cmd.t
(** Cmdliner command definition wired into {!Ono_main}. *)
