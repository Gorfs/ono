(** Plain-text back-end for the concrete ono runtime.

    Default output mode: prints integers, newlines and cells to stdout, and
    reads integers from stdin. *)

val functions : (string * Kdo.Concrete.Extern_func.extern_func) list
(** Bindings exposed to Wasm: [print_i32], [print_i64], [read_int], [newline],
    [clear_screen], [print_cell]. *)
