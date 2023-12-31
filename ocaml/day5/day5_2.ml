let file = "input.txt"

type mapping = { dest : int; src : int; len : int }

let rec group2 lst =
  match lst with
  | first :: second :: rest -> (first, second) :: group2 rest
  | _ :: [] -> raise Exit
  | [] -> []

let find_min lst =
  lst |> List.fold_left (fun a b -> if a < b then a else b) max_int

let parse_seeds str =
  str |> String.split_on_char ':' |> List.tl |> List.hd |> String.trim
  |> String.split_on_char ' ' |> List.map int_of_string |> group2
  |> List.map (fun (s, len) -> (s, s + len))

let parse_mapping str =
  match str |> String.split_on_char ' ' |> List.map int_of_string with
  | [ first; second; third ] -> { dest = first; src = second; len = third }
  | _ -> raise Exit

let parse_maps lst =
  lst
  |> List.map (fun str ->
         str |> String.split_on_char ':' |> List.tl |> List.hd |> String.trim
         |> String.split_on_char '\n' |> List.map parse_mapping)

let parse_input str =
  match str |> Str.split (Str.regexp "\n\n") with
  | first :: rest -> (parse_seeds first, parse_maps rest)
  | _ -> raise Exit

let lookup m input = input - m.src + m.dest

let overlap (s1, e1) (s2, e2) =
  let s = if s1 < s2 then s2 else s1 in
  let e = if e1 < e2 then e1 else e2 in
  if e > s then Some (s, e) else None

let rec traverse_mappings mappings (s1, e1) =
  if s1 < e1 then
    match mappings with
    | m :: rest -> (
        match overlap (s1, e1) (m.src, m.src + m.len) with
        | Some (s2, e2) ->
            (lookup m s2, lookup m e2)
            :: (traverse_mappings rest (s1, s2)
               @ traverse_mappings rest (e2, e1))
        | None -> traverse_mappings rest (s1, e1))
    | [] -> [ (s1, e1) ]
  else []

let rec traverse_maps maps input =
  match maps with
  | mp :: rest ->
      traverse_mappings mp input
      |> List.map (fun input' -> traverse_maps rest input')
      |> find_min
  | [] -> fst input

let () =
  let ic = open_in file in
  try
    let seeds, maps = In_channel.input_all ic |> parse_input in
    seeds
    |> List.map (fun seed -> traverse_maps maps seed)
    |> find_min |> print_int;
    print_newline ();
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
