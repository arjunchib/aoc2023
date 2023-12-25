let file = "input.txt"

type range = { dest_start : int; src_start : int; length : int }

let make_seq (start, length) = Seq.init length (fun x -> start + x)

let rec partition_alternating l =
  match l with
  | fst :: snd :: l -> (fst, snd) :: partition_alternating l
  | _ -> []

let parse_seeds seed_str =
  match seed_str |> String.split_on_char ':' with
  | _ :: seeds :: _ ->
      seeds |> String.trim |> String.split_on_char ' ' |> List.map int_of_string
      |> partition_alternating |> List.map make_seq
      |> List.fold_left (fun accu s -> Seq.append accu s) Seq.empty
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
  match
    lines
    |> List.map (fun line -> match line with "" -> "," | _ -> line)
    |> List.fold_left join "" |> String.split_on_char ','
  with
  | seed_str :: map_str -> (parse_seeds seed_str, map_str |> List.map parse_maps)
  | _ -> raise Exit

let memo_rec f =
  let h = Hashtbl.create 16 in
  let rec g x =
    try Hashtbl.find h x
    with Not_found ->
      let y = f g x in
      Hashtbl.add h x y;
      y
  in
  g

let () =
  let ic = open_in file in
  try
    let seeds, maps = In_channel.input_lines ic |> parse_input in
    let memo_traverse =
      let traverse_map self (input, i) =
        match List.nth_opt maps i with
        | None -> input
        | Some map -> (
            match
              map
              |> List.find_opt (fun r ->
                     input >= r.src_start && input < r.src_start + r.length)
            with
            | Some r -> self (r.dest_start + (input - r.src_start), i + 1)
            | None -> self (input, i + 1))
      in
      memo_rec traverse_map
    in
    seeds
    |> Seq.map (fun seed -> memo_traverse (seed, 0))
    |> Seq.fold_left min max_int |> print_int;
    print_newline ();
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
