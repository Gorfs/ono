(* The `ono concrete` command. *)

open Cmdliner
open Ono_cli

let seed_generator seed =
  match seed with None -> Random.self_init () | Some s -> Random.init s

let info = Cmd.info "concrete" ~exits

let normalize_option_int x =
  match x with None -> 0 | Some n when n < 0 -> 0 | Some n -> n

let normalize_option_bool x = match x with None -> false | Some b -> b

let term =
  let open Term.Syntax in
  let+ () = setup_log
  and+ seed = seed
  and+ source_file = source_file
  and+ use_graphical_window = use_graphical_window
  and+ steps = steps
  and+ display_last = display_last in
  (* and+ config_file = config_file in *)
  seed_generator seed;
  Ono.Concrete_driver.run ~source_file
    (normalize_option_bool use_graphical_window)
    (normalize_option_int steps)
    (normalize_option_int display_last)
  |> function
  | Ok () -> Ok ()
  | Error e -> Error (`Msg (Kdo.R.err_to_string e))

let cmd : Ono_cli.outcome Cmd.t = Cmd.v info term
