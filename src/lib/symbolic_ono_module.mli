(** Symbolic ono runtime module.

    Provides the externs exposed to a Wasm program under symbolic execution:
    [print_i32], fresh symbolic [i32] values, and a (concrete) stdin reader.

    This module is linked against the user program under the name ["ono"]. *)

val m : Owi.Symbolic_extern_func.extern_func Owi.Extern.Module.t
(** The extern module bundling all symbolic ono primitives, ready to be
    passed to {!Owi.Link.Extern.modul}. *)
