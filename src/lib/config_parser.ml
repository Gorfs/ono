let read_lines filename =
  let ic = open_in filename in
  let rec aux acc =
    try
      let line = input_line ic in
      aux (line :: acc)
    with End_of_file ->
      close_in ic;
      List.rev acc
  in
  aux []

let load_file filename =
  let lines = read_lines filename in
  match lines with
  | [] -> failwith "Empty grid file"
  | first :: _ ->
      let width = String.length first in
      Array.of_list
        (List.map
           (fun line ->
             if String.length line <> width then
               failwith "Lines must have same length";

             Array.init width (fun j ->
                 match line.[j] with
                 | '1' -> 1
                 | '0' -> 0
                 | _ -> failwith "Invalid character"))
           lines)
