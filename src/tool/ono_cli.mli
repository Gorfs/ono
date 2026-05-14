(** Shared command-line plumbing for the [ono] executable.

    Defines the outcome type, exit codes, common [Cmdliner] arguments and the
    log setup used by both the concrete and symbolic subcommands. *)

type outcome = (unit, [ Ono.Error.t | Cmdliner.Cmd.eval_error ]) Result.t
(** What a subcommand evaluation returns: either [Ok ()] or a tagged error from
    the ono runtime or from Cmdliner itself. *)

val error_to_exit_code : Ono.Error.t -> int
(** Maps an {!Ono.Error.t} to a stable process exit code (see {!exits}). *)

val err_conversion_to_integer : int
val err_unreachable : int
val err_integer_divide_by_zero : int
val err_integer_overflow : int
val err_call_stack_exhausted : int
val err_out_of_bounds_memory_access : int
val err_msg : int

val exits : Cmdliner.Cmd.Exit.info list
(** Exit code documentation for the [ono] manpage, including Wasm runtime
    failures (unreachable, division by zero, …). *)

val sdocs : string
(** Section header under which common options are documented. *)

val version : string
(** Version string surfaced by [ono --version]. *)

val setup_log : unit Cmdliner.Term.t
(** Cmdliner term that configures the [Logs] and [Fmt] reporters from the
    standard [--verbosity] / [--color] flags. *)

val seed : int option Cmdliner.Term.t
(** [--seed N] — seed for the random number generator. *)

val use_graphical_window : bool option Cmdliner.Term.t
(** [--use-graphical-window BOOL] — render output through the GUI. *)

val steps : int option Cmdliner.Term.t
(** [--steps N] — number of simulation steps. *)

val display_last : int option Cmdliner.Term.t
(** [--display-last N] — only display the last N configurations. *)

val config_file : Fpath.t option Cmdliner.Term.t
(** [--config FILE] — initial configuration file. *)

val source_file : Fpath.t Cmdliner.Term.t
(** Positional argument: the WAT source file to analyse. *)

val speed : int option Cmdliner.Term.t
(** [--speed N] — delay between simulation steps, in milliseconds. *)

val no_stop_at_failure : bool Cmdliner.Term.t
(** [--no-stop-at-failure] — for symbolic execution, keep exploring after the
    first failing path. *)
