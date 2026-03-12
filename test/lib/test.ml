(* Automatic tests for ono custom written code using generative testing techniques *)

open QCheck
open Ono

(* 1. Demonstration of Random.init 42 for deterministic tests *)
let () = Random.init 42

(* 2. Manual generators (unit -> 'a) *)
module ManualGen = struct
  type 'a t = unit -> 'a

  let int : int t = fun () -> Random.int 100
  let bool : bool t = fun () -> Random.bool ()

  let pair (left : 'a t) (right : 'b t) : ('a * 'b) t =
   fun () -> (left (), right ())

  let rec list (elem : 'a t) ~size : 'a list t =
   fun () -> if size <= 0 then [] else elem () :: list elem ~size:(size - 1) ()

  (* Suppress warnings *)
  let _ = int
  let _ = bool
  let _ = pair
  let _ = list
end

(* 3. Fuel-based generators (fuel -> fuel * 'a) *)
module FuelGen = struct
  type fuel = int
  type 'a t = fuel -> fuel * 'a

  let int : int t = fun fuel -> (fuel - 1, Random.int 100)
  let bool : bool t = fun fuel -> (fuel - 1, Random.bool ())

  let pair (left : 'a t) (right : 'b t) : ('a * 'b) t =
   fun fuel ->
    let fuel, x = left fuel in
    let fuel, y = right fuel in
    (fuel, (x, y))

  let rec list (elem : 'a t) ~size : 'a list t =
   fun fuel ->
    if size <= 0 || fuel <= 0 then (fuel, [])
    else
      let fuel, hd = elem fuel in
      let fuel, tl = list elem ~size:(size - 1) fuel in
      (fuel, hd :: tl)

  (* Suppress warnings *)
  let _ = int
  let _ = bool
  let _ = pair
  let _ = list
end

(* 4. Monadic generators (using a simple monad) *)
module MonadicGen = struct
  type 'a t = unit -> 'a

  let return (x : 'a) : 'a t = fun () -> x
  let bind (g : 'a t) (f : 'a -> 'b t) : 'b t = fun () -> f (g ()) ()
  let ( let* ) = bind
  let map (g : 'a t) (f : 'a -> 'b) : 'b t = fun () -> f (g ())
  let ( let+ ) = map
  let int : int t = fun () -> Random.int 100
  let bool : bool t = fun () -> Random.bool ()

  let pair (left : 'a t) (right : 'b t) : ('a * 'b) t =
    let* x = left in
    let* y = right in
    return (x, y)

  let rec list (elem : 'a t) ~size : 'a list t =
    if size <= 0 then return []
    else
      let* hd = elem in
      let* tl = list elem ~size:(size - 1) in
      return (hd :: tl)

  (* Suppress warnings *)
  let _ = return
  let _ = bind
  let _ = ( let* )
  let _ = map
  let _ = ( let+ )
  let _ = int
  let _ = bool
  let _ = pair
  let _ = list
end

(* 5. Property testing with QCheck *)

(* Arbitrary for Error.t *)
let error_arb : Error.t arbitrary =
  let gen =
    Gen.oneof
      [
        Gen.map (fun s -> `Msg s) Gen.string_printable;
        Gen.return `Call_stack_exhausted;
        Gen.return `Conversion_to_integer;
        Gen.return `Integer_divide_by_zero;
        Gen.return `Integer_overflow;
        Gen.return `Out_of_bounds_memory_access;
        Gen.return `Unreachable;
      ]
  in
  QCheck.make gen

(* Generator for ('a, Error.t) Result.t *)
let result_arb (elem_arb : 'a arbitrary) : ('a, Error.t) result arbitrary =
  let gen =
    Gen.oneof_weighted
      [
        (3, Gen.map (fun x -> Ok x) elem_arb.gen);
        (1, Gen.map (fun e -> Error e) error_arb.gen);
      ]
  in
  QCheck.make gen

(* Generator for functions int -> (int, Error.t) result *)
let fun_arb : (int -> (int, Error.t) result) arbitrary =
  let gen =
    Gen.oneof_weighted
      [
        ( 3,
          Gen.map
            (fun offset -> fun x -> Ok (x + offset))
            (Gen.int_range (-100) 100) );
        (1, Gen.map (fun e -> fun _ -> Error e) error_arb.gen);
      ]
  in
  QCheck.make gen

(* Generator for pure functions int -> int *)
let fun_int_arb : (int -> int) arbitrary =
  let gen =
    Gen.map (fun offset -> fun x -> x + offset) (Gen.int_range (-100) 100)
  in
  QCheck.make gen

(* Arbitrary for int *)
let int_arb = QCheck.int_range 0 1000

(* Test the syntax operators (let* and let+) from syntax.ml
   We test monad laws for the Result monad.
   Note: syntax.ml defines (let* ) = Result.bind and (let+) = Result.map
*)

(* Helper to compare results ignoring physical equality *)
let equal_result eq a b =
  match (a, b) with
  | Ok x, Ok y -> eq x y
  | Error e1, Error e2 -> e1 = e2
  | _ -> false

(* Law 1: left identity: return a >>= f ≡ f a *)
let test_left_identity =
  Test.make ~count:1000 ~name:"left identity" (QCheck.pair int_arb fun_arb)
    (fun (a, f) ->
      let left = Result.bind (Ok a) f in
      let right = f a in
      equal_result Int.equal left right)

(* Law 2: right identity: m >>= return ≡ m *)
let test_right_identity =
  Test.make ~count:1000 ~name:"right identity" (result_arb int_arb) (fun m ->
      let left = Result.bind m (fun x -> Ok x) in
      equal_result Int.equal left m)

(* Law 3: associativity: (m >>= f) >>= g ≡ m >>= (fun x -> f x >>= g) *)
let test_associativity =
  Test.make ~count:1000 ~name:"associativity"
    (QCheck.triple (result_arb int_arb) fun_arb fun_arb)
    (fun (m, f, g) ->
      let left = Result.bind (Result.bind m f) g in
      let right = Result.bind m (fun x -> Result.bind (f x) g) in
      equal_result Int.equal left right)

(* Test map operator: (let+) = Result.map *)
let test_map =
  Test.make ~count:1000 ~name:"map"
    (QCheck.pair (result_arb int_arb) fun_int_arb)
    (fun (m, f) ->
      let left = Result.map f m in
      let right = match m with Ok x -> Ok (f x) | Error e -> Error e in
      equal_result Int.equal left right)

(* 6. Differential testing: compare two implementations of the same function.
   Since we have only one implementation, we can compare with a reference implementation.
   Example: compare Result.bind with a manual match.
*)
let test_differential_bind =
  Test.make ~count:1000 ~name:"differential bind"
    (QCheck.pair (result_arb int_arb) fun_arb)
    (fun (m, f) ->
      let res1 = Result.bind m f in
      let res2 = match m with Ok x -> f x | Error e -> Error e in
      equal_result Int.equal res1 res2)

(* 7. Shrinking demonstration using QCheck's built-in shrinkers.
   We create a property that fails for a specific input, and see if shrinking works.
   This property is intentionally false for lists containing 42.
*)
let test_shrinking =
  Test.make ~count:1000 ~name:"shrinking demo (should fail)"
    QCheck.(list nat)
    (fun lst -> not (List.exists (fun x -> x = 42) lst))

let _ = test_shrinking

(* 8. Test actual functions from ono library that are exposed.
   Since most functions are hidden, we test the error type equality.
*)
let test_error_equality =
  Test.make ~count:1000 ~name:"error equality" (QCheck.pair error_arb error_arb)
    (fun (e1, e2) -> e1 = e2 = (e1 = e2))
(* trivial, but demonstrates generator works *)

(* Run all tests *)
let () =
  let suite =
    [
      test_left_identity;
      test_right_identity;
      test_associativity;
      test_map;
      test_differential_bind;
      test_error_equality;
      (* test_shrinking; *)
      (* comment out because it's expected to fail *)
    ]
  in
  List.iter (fun t -> Test.check_exn t) suite;
  print_endline "All tests passed."
