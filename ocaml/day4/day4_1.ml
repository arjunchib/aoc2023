let file = "input.txt"

let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n ->
      let b = pow a (n / 2) in
      b * b * if n mod 2 = 0 then 1 else a

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

let total_points (winning_nums, nums) =
  let num_winners =
    nums
    |> List.filter (fun num ->
           winning_nums |> List.exists (fun wnum -> wnum == num))
    |> List.length
  in
  match num_winners with 0 -> 0 | _ -> pow 2 (num_winners - 1)

let () =
  let ic = open_in file in
  try
    In_channel.input_lines ic |> List.map numbers |> List.map total_points
    |> List.fold_left ( + ) 0 |> string_of_int |> print_endline;
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
