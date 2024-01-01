let file = "input.txt"
let pop input = match input with _ :: rest -> rest | _ -> []

let parse_input input =
  let lines =
    input
    |> List.map (fun line ->
           line |> String.split_on_char ' '
           |> List.filter (fun x -> String.length x > 0)
           |> pop |> List.map int_of_string)
  in
  List.combine (List.hd lines) (List.nth lines 1)

let bounds (time, dist) =
  let a = -1. in
  let b = float_of_int time in
  let c = -1. *. float_of_int dist in
  (* this is an epsilon value to disregard the exact roots - this is bad but im lazy *)
  let e = 0.0000001 in
  let discriminant = Float.pow b 2. -. (4. *. a *. c) in
  let x1 = ((-.b +. Float.sqrt discriminant) /. (2. *. a)) +. e in
  let x2 = ((-.b -. Float.sqrt discriminant) /. (2. *. a)) -. e in
  (* Printf.printf "(%f, %f)" x1 x2; *)
  (int_of_float (Float.ceil x1), int_of_float (Float.floor x2))

let () =
  let ic = open_in file in
  try
    let records = In_channel.input_lines ic |> parse_input in
    (* records |> List.iter (fun (d, t) -> Printf.printf "(%d, %d)" d t); *)
    records |> List.map bounds
    |> List.map (fun (r1, r2) -> r2 - r1 + 1)
    |> List.fold_left ( * ) 1 |> print_int;
    print_newline ();
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
