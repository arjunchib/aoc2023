let file = "input.txt"

let parse_input input =
  let lines =
    input
    |> List.map (fun line ->
           line |> String.split_on_char ':' |> List.tl |> List.hd
           |> Str.global_replace (Str.regexp " ") ""
           |> int_of_string)
  in
  (List.hd lines, List.nth lines 1)

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
    let record = In_channel.input_lines ic |> parse_input in
    (* records |> List.iter (fun (d, t) -> Printf.printf "(%d, %d)" d t); *)
    let r1, r2 = record |> bounds in
    print_int (r2 - r1 + 1);
    print_newline ();
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
