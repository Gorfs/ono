(** Symbolic execution driver for ono.

    Parses a WAT source file, compiles it to Wasm, validates and links it
    against the symbolic ono runtime, then explores all reachable paths with
    the Owi symbolic interpreter (Z3 backed, FIFO exploration). *)

val run :
  source_file:Fpath.t ->
  no_stop_at_failure:bool ->
  (unit, [> `Msg of string ]) result
(** [run ~source_file ~no_stop_at_failure] symbolically executes the WAT
    module at [source_file].

    When [no_stop_at_failure] is [true], the exploration continues after the
    first failing path instead of stopping. *)
