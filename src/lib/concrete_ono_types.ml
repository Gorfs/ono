type extern_func = Kdo.Concrete.Extern_func.extern_func

type instructionSet = {
  print_i32 : Kdo.Concrete.I32.t -> (unit, Owi.Result.err) Result.t;
  print_i64 : Kdo.Concrete.I64.t -> (unit, Owi.Result.err) Result.t;
  read_int : unit -> (Kdo.Concrete.I32.t, Owi.Result.err) Result.t;
}
