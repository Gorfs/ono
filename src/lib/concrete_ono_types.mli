(** Shared types for the concrete ono runtime.

    Groups the externs that both the text and GUI back-ends must implement,
    so they can be assembled into a uniform set of primitives. *)

type extern_func = Kdo.Concrete.Extern_func.extern_func
(** Alias for the underlying Owi concrete extern-function type. *)

type instructionSet = {
  print_i32 : Kdo.Concrete.I32.t -> (unit, Owi.Result.err) Result.t;
  print_i64 : Kdo.Concrete.I64.t -> (unit, Owi.Result.err) Result.t;
  read_int : unit -> (Kdo.Concrete.I32.t, Owi.Result.err) Result.t;
}
(** Concrete back-end interface: the trio of primitives that every output
    mode (text, GUI, …) must provide. *)
