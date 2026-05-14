(** Error type for the ono runtime.

    Covers the message-based [`Msg] errors raised by ono itself and the
    Wasm-level traps surfaced by Owi (unreachable, division by zero, …). *)

type t =
  [ `Msg of string
  | `Call_stack_exhausted
  | `Conversion_to_integer
  | `Integer_divide_by_zero
  | `Integer_overflow
  | `Out_of_bounds_memory_access
  | `Unreachable ]
(** All error tags ono can produce. Each non-[`Msg] tag corresponds to a
    Wasm trap and is mapped to a dedicated process exit code by the CLI
    layer. *)
