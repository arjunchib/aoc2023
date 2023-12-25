let file = "input.txt"

type range = { dest_start : int; src_start : int; length : int }

let parse_seeds seed_str =
  match seed_str |> String.split_on_char ':' with
  | _ :: seeds :: _ ->
      seeds |> String.trim |> String.split_on_char ' ' |> List.map int_of_string
  | _ -> raise Exit

let parse_map map_str =
  match
    map_str |> String.trim |> String.split_on_char ' ' |> List.map int_of_string
  with
  | dest :: src :: len :: _ ->
      { dest_start = dest; src_start = src; length = len }
  | _ -> raise Exit

let parse_maps map_str =
  match map_str |> String.split_on_char ':' with
  | _ :: maps :: _ ->
      maps |> String.trim |> String.split_on_char '\n' |> List.map parse_map
  | _ -> raise Exit

let join a b = a ^ "\n" ^ b

let parse_input lines =
  (* lines
     |> List.map (fun line -> match line with "" -> "," | _ -> line)
     |> List.fold_left join "" |> print_endline; *)
  match
    lines
    |> List.map (fun line -> match line with "" -> "," | _ -> line)
    |> List.fold_left join "" |> String.split_on_char ','
  with
  | seed_str :: map_str -> (parse_seeds seed_str, map_str |> List.map parse_maps)
  | _ -> raise Exit

let traverse_map input map =
  (* print_int input;
     map
     |> List.iter (fun map ->
            Printf.printf "(%d,%d,%d)" map.dest_start map.src_start map.length);
     print_string " "; *)
  match
    map
    |> List.find_opt (fun r ->
           input >= r.src_start && input < r.src_start + r.length)
  with
  | Some r -> r.dest_start + (input - r.src_start)
  | None -> input

let () =
  let ic = open_in file in
  try
    let seeds, maps = In_channel.input_lines ic |> parse_input in
    seeds
    |> List.map (fun seed ->
           (* print_newline (); *)
           maps |> List.fold_left traverse_map seed)
    |> List.fold_left min max_int |> print_int;
    print_newline ();
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
