let file = "input.txt"

type card = J | C2 | C3 | C4 | C5 | C6 | C7 | C8 | C9 | T | Q | K | A

type category =
  | High_card
  | One_pair
  | Two_pair
  | Three_of_a_kind
  | Full_house
  | Four_of_a_kind
  | Five_of_a_kind

type hand = { cards : card list; category : category; bet : int }

module Card = struct
  type t = card

  let compare = compare
end

module CardMap = Map.Make (Card)

let card_of_char = function
  | 'A' -> A
  | 'K' -> K
  | 'Q' -> Q
  | 'J' -> J
  | 'T' -> T
  | '9' -> C9
  | '8' -> C8
  | '7' -> C7
  | '6' -> C6
  | '5' -> C5
  | '4' -> C4
  | '3' -> C3
  | '2' -> C2
  | _ -> raise Exit

(* let char_of_card = function
   | A -> 'A'
   | K -> 'K'
   | Q -> 'Q'
   | J -> 'J'
   | T -> 'T'
   | C9 -> '9'
   | C8 -> '8'
   | C7 -> '7'
   | C6 -> '6'
   | C5 -> '5'
   | C4 -> '4'
   | C3 -> '3'
   | C2 -> '2' *)

(* let string_of_category = function
   | Five_of_a_kind -> "5 kind"
   | Four_of_a_kind -> "4 kind"
   | Full_house -> "Full house"
   | Three_of_a_kind -> "3 kind"
   | Two_pair -> "2 pair"
   | One_pair -> "1 pair"
   | High_card -> "High card" *)

let add_if_exists value =
  match value with Some x -> Some (x + 1) | None -> Some 1

let add_to_head v l =
  match l with head :: rest -> (head + v) :: rest | [] -> [ v ]

let find_category cards =
  let num_jokers = cards |> List.filter (fun c -> c = J) |> List.length in
  let counts =
    cards
    |> List.filter (fun c -> c <> J)
    |> List.fold_left
         (fun m c -> CardMap.update c add_if_exists m)
         CardMap.empty
    |> CardMap.bindings |> List.map snd |> List.sort compare |> List.rev
    |> add_to_head num_jokers
  in
  (* List.iter (Printf.printf "%d ") counts;
     print_newline (); *)
  match counts with
  | [ 5 ] -> Five_of_a_kind
  | [ 4; 1 ] -> Four_of_a_kind
  | [ 3; 2 ] -> Full_house
  | [ 3; 1; 1 ] -> Three_of_a_kind
  | [ 2; 2; 1 ] -> Two_pair
  | [ 2; 1; 1; 1 ] -> One_pair
  | _ -> High_card

let parse_input line =
  let h = String.split_on_char ' ' line in
  let cards =
    h |> List.hd |> String.to_seq |> Seq.map card_of_char |> List.of_seq
  in
  {
    cards;
    category = find_category cards;
    bet = h |> List.tl |> List.hd |> int_of_string;
  }

let compare_cards a b =
  let rec inner_compare cards =
    match cards with
    | (a, b) :: list -> if a = b then inner_compare list else compare a b
    | _ -> 0
  in
  List.combine a b |> inner_compare

let compare_hands a b =
  if a.category = b.category then compare_cards a.cards b.cards
  else compare a.category b.category

let hand_winnings i h = (i + 1) * h.bet

let () =
  let ic = open_in file in
  try
    let hands = In_channel.input_lines ic |> List.map parse_input in
    (* hands |> List.sort compare_hands
       |> List.iteri (fun i h ->
              Printf.printf "%d %d %s\n" (i + 1) h.bet
                (string_of_category h.category)); *)
    hands |> List.sort compare_hands |> List.mapi hand_winnings
    |> List.fold_left ( + ) 0 |> print_int;
    print_newline ();
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
