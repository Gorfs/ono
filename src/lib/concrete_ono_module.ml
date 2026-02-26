let random_i32 () : (Kdo.Concrete.I32.t, Owi.Result.err) Result.t =
  let n = Random.int32 Int32.max_int in
  Ok (Kdo.Concrete.I32.of_int32 n)

let sleep (duration : Kdo.Concrete.I32.t) : (unit, Owi.Result.err) Result.t =
  Unix.sleepf (float_of_int (Kdo.Concrete.I32.to_int duration) /. 1000.0);
  Ok ()

let m (use_graphical_window : bool) (steps : int) (display_last : int) =
  let casted_steps = Int32.of_int steps in
  let casted_display_last = Int32.of_int display_last in
  let open Kdo.Concrete.Extern_func in
  let open Kdo.Concrete.Extern_func.Syntax in
  let baseInstructions =
    [
      ("random_i32", Extern_func (unit ^->. i32, random_i32));
      ( "get_steps",
        Extern_func
          (unit ^->. i32, fun () -> Ok (Kdo.Concrete.I32.of_int32 casted_steps))
      );
      ( "get_display_last",
        Extern_func
          ( unit ^->. i32,
            fun () -> Ok (Kdo.Concrete.I32.of_int32 casted_display_last) ) );
      ( "sleep",
        Extern_func
          (i32 ^->. unit, fun (duration : Kdo.Concrete.I32.t) -> sleep duration)
      );
    ]
  in
  let functions =
    if use_graphical_window then
      List.append baseInstructions Concrete_ono_gui.functions
    else List.append baseInstructions Concrete_ono_text.functions
  in
  {
    Kdo.Extern.Module.functions;
    func_type = Kdo.Concrete.Extern_func.extern_type;
  }
