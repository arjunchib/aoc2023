let file = "input.txt"

type direction = Left | Right | Both

let explode s = List.init (String.length s) (String.get s)
let is_numeric = function '0' .. '9' -> true | _ -> false

let window =
  let window_i = List.to_seq [ -1; 0; 1 ] in
  Seq.product window_i window_i |> List.of_seq

let () =
  (* window |> List.iter (fun (x, y) -> Printf.printf "(%i, %i)" x y); *)
  let ic = open_in file in
  try
    let lines = In_channel.input_lines ic in
    let height = List.length lines in
    let width = List.hd lines |> String.length in

    let in_bounds (x, y) = x >= 0 && x < width && y >= 0 && y < height in

    let rec parts (x, y) dir =
      if in_bounds (x, y) then
        let line = List.nth lines y in
        let c = line.[x] in
        if is_numeric c then
          let s = String.make 1 c in
          match dir with
          | Left -> parts (x - 1, y) Left ^ s
          | Right -> s ^ parts (x + 1, y) Right
          | Both -> parts (x - 1, y) Left ^ s ^ parts (x + 1, y) Right
        else ""
      else ""
    in

    let gear_ratio x y =
      let parts_locs =
        window
        |> List.map (fun (x', y') -> (x + x', y + y'))
        |> List.filter in_bounds
        |> List.filter (fun (x', y') -> is_numeric (List.nth lines y').[x'])
      in

      let unique (x', y') =
        match
          parts_locs
          |> List.find_index (fun (x'', y'') -> x' == x'' && y' == y'')
        with
        | Some i -> i
        | None -> -1
      in

      let unique_part_locs =
        parts_locs
        |> List.filteri (fun i (x', y') ->
               unique (x' - 1, y') < i && unique (x' + 1, y') < i)
      in

      match List.length unique_part_locs with
      | 2 ->
          (* unique_part_locs
             |> List.iter (fun (i, j) -> Printf.printf "(%i, %i)" i j);
             print_endline ""; *)
          unique_part_locs
          |> List.map (fun pair -> parts pair Both)
          |> List.map int_of_string |> List.fold_left ( * ) 1
      | _ -> 0
    in

    lines
    |> List.mapi (fun y line ->
           explode line
           |> List.mapi (fun x c ->
                  match c with '*' -> gear_ratio x y | _ -> 0))
    |> List.flatten |> List.fold_left ( + ) 0 |> string_of_int |> print_endline;
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
