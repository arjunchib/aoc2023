let file = "input.txt"

let () =
  let ic = open_in file in
  try
    (* variables *)
    let lines = In_channel.input_lines ic in
    let height = List.length lines in
    let width = List.hd lines |> String.length in
    let window = begin
      let window_i = List.to_seq [ -1; 0; 1 ] in
      Seq.product window_i window_i
    end in

    (* helpers *)
    let clamp x y = begin
      if x >= 0 && y >= 0 && x < width && y < height then Some (x, y) else None
    end in
    let find_symbols i line = begin
      String.to_seq line |>
      Seq.mapi begin fun j c -> match c with 
        | '.' -> None
        | '0'..'9' -> None
        | _ -> Some (j, i)
      end |>
      Seq.filter_map (fun x -> x) |>
      Seq.flat_map begin fun (x, y) ->
        Seq.filter_map (fun (i2, j2) -> clamp (x + i2) (y + j2)) window
      end
    end in


    (* main *)
    let symbols = List.to_seq lines |>
    Seq.mapi find_symbols |>
    Seq.flat_map (fun x -> x) in

    lines |>
    List.mapi begin fun y line -> 
      let symbol_nearby i j = begin
        Seq.exists (fun (i2, j2) -> i == i2 && j == j2) symbols 
      end in
      let rec parts x part has_symbol = begin
        (* print_endline (Printf.sprintf "(%i, %i, %s, %b)" x y part has_symbol); *)
        if x >= width then if has_symbol then int_of_string part else 0 else
        let c = line.[x] in 
        match c with
        | '0'..'9' -> parts (x + 1) (part ^ String.make 1 c) (symbol_nearby x y || has_symbol)
        | _ -> 
          (if has_symbol then int_of_string part else 0) + parts (x + 1) "" false
      end in
      parts 0 "" false
    end |>
    List.fold_left ( + ) 0 |>
    string_of_int |>
    print_endline;

    (* print list *)
    (* List.iter print_endline lines; *)

    (* print symbols *)
    (* Seq.map (fun (x, y) -> Printf.sprintf "(%i, %i)" x y) symbols |>
    Seq.iter print_endline; *)
    close_in ic;
  with e ->
    close_in_noerr ic;
    raise e;
