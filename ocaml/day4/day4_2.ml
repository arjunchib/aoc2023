let file = "input.txt"

let int_list_of_string value =
  value |> String.split_on_char ' '
  |> List.filter (fun c -> c <> "")
  |> List.map int_of_string

let numbers line =
  match line |> String.split_on_char ':' with
  | _ :: card :: _ ->
      let nums =
        card |> String.split_on_char '|' |> List.map int_list_of_string
      in
      (List.nth nums 0, List.nth nums 1)
  | _ -> ([ 0 ], [ 0 ])

let num_winners (winning_nums, nums) =
  nums
  |> List.filter (fun num ->
         winning_nums |> List.exists (fun wnum -> wnum == num))
  |> List.length

let () =
  let ic = open_in file in
  try
    let lines = In_channel.input_lines ic in
    let cards, wins =
      lines |> List.map numbers |> List.map num_winners
      |> List.map (fun wins -> (1, wins))
      |> List.to_seq |> Array.of_seq |> Array.split
    in

    wins
    |> Array.iteri (fun index num_wins ->
           let curr_card = cards.(index) in
           for i = index + 1 to index + num_wins do
             let card' = cards.(i) in
             cards.(i) <- card' + curr_card
           done);

    (* Array.iter2 (fun c w -> Printf.printf "(%i, %i)" c w) cards wins; *)
    cards |> Array.fold_left ( + ) 0 |> print_int;
    print_newline ();

    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
