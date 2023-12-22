let file = "test.txt"

let () =
  let ic = open_in file in
  try
    let lines = In_channel.input_lines ic in
    let width = List.length lines in
    let height = List.hd lines |> String.length in
    let clamp x y = begin
      if x >= 0 && y >= 0 && x < width && y < height then Some (x, y) else None
    end in
    let window = begin
      let window_i = [ -1; 0; 1 ] in
      window_i |>
      List.map (fun x -> List.map (fun y -> (x, y)) window_i) |>
      List.flatten
    end in
    let find_symbols i line = begin
      String.to_seq line |>
      Seq.mapi begin fun j c -> match c with 
        | '.' -> None
        | '0'..'9' -> None
        | _ -> Some (i, j)
      end |>
      Seq.filter_map (fun x -> x) |>
      Seq.flat_map begin fun (x, y) ->
        List.to_seq (List.filter_map (fun (i, j) -> clamp (x + i) (y + j)) window)
      end
    end in
    let symbols = List.to_seq lines |>
    Seq.mapi find_symbols |>
    Seq.flat_map (fun x -> x) in
    List.iter print_endline lines;
    Seq.map (fun (x, y) -> Printf.sprintf "(%i, %i)" x y) symbols |>
    Seq.iter print_endline;
    close_in ic;
  with e ->
    close_in_noerr ic;
    raise e;
