
(* Custom exception for empty dataset *)
exception Empty_dataset of string

(* Type definitions for clarity *)
type statistics = {
  mean : float;
  median : float;
  mode : int;
  mode_frequency : int;
}

(* 
   Calculate the mean (average) of a list of integers
   Uses fold_left to sum elements and List.length to get count
   @param data: list of integers
   @return: mean value as float
*)
let calculate_mean (data : int list) : float =
  match data with
  | [] -> raise (Empty_dataset "Cannot calculate mean of empty dataset")
  | _ ->
      let sum = List.fold_left (+) 0 data in
      let count = List.length data in
      float_of_int sum /. float_of_int count

(*
   Calculate the median of a list of integers
   Uses List.sort for sorting and pattern matching for indexing
   @param data: list of integers
   @return: median value as float
*)
let calculate_median (data : int list) : float =
  match data with
  | [] -> raise (Empty_dataset "Cannot calculate median of empty dataset")
  | _ ->
      (* Sort the list (creates a new sorted list, original unchanged) *)
      let sorted_data = List.sort compare data in
      let n = List.length sorted_data in
      
      (* Helper function to get nth element from list *)
      let rec nth_element lst idx =
        match (lst, idx) with
        | ([], _) -> raise (Failure "Index out of bounds")
        | (h :: _, 0) -> h
        | (_ :: t, i) -> nth_element t (i - 1)
      in
      
      (* Calculate median based on odd/even length *)
      if n mod 2 = 1 then
        float_of_int (nth_element sorted_data (n / 2))
      else
        let mid1 = nth_element sorted_data (n / 2 - 1) in
        let mid2 = nth_element sorted_data (n / 2) in
        (float_of_int mid1 +. float_of_int mid2) /. 2.0

(*
   Calculate the mode (most frequently occurring value) of a list
   Uses fold_left to build frequency map and find maximum
   @param data: list of integers
   @return: tuple of (mode_value, frequency)
*)
let calculate_mode (data : int list) : (int * int) =
  match data with
  | [] -> raise (Empty_dataset "Cannot calculate mode of empty dataset")
  | _ ->
      (* Build frequency map using association list (immutable) *)
      let frequency_map = 
        List.fold_left
          (fun acc elem ->
             (* Check if element exists in association list *)
             let current_count = 
               try List.assoc elem acc 
               with Not_found -> 0 
             in
             (* Create new association list with updated count *)
             let updated_list = List.remove_assoc elem acc in
             (elem, current_count + 1) :: updated_list
          )
          []
          data
      in
      
      (* Find the element with maximum frequency *)
      let (mode_value, max_freq) = 
        List.fold_left
          (fun (curr_mode, curr_max) (value, freq) ->
             if freq > curr_max then (value, freq)
             else (curr_mode, curr_max)
          )
          (fst (List.hd frequency_map), snd (List.hd frequency_map))
          frequency_map
      in
      (mode_value, max_freq)

(*
   Calculate all statistics at once
   @param data: list of integers
   @return: statistics record
*)
let calculate_all_statistics (data : int list) : statistics =
  let mean_val = calculate_mean data in
  let median_val = calculate_median data in
  let (mode_val, mode_freq) = calculate_mode data in
  {
    mean = mean_val;
    median = median_val;
    mode = mode_val;
    mode_frequency = mode_freq;
  }

(*
   Display statistics in a formatted manner
   @param data: list of integers
   @param stats: statistics record
*)
let print_statistics (data : int list) (stats : statistics) : unit =
  Printf.printf "\n%s\n" (String.make 50 '=');
  Printf.printf "STATISTICAL ANALYSIS RESULTS\n";
  Printf.printf "%s\n" (String.make 50 '=');
  
  (* Display data - convert list to string using map and fold *)
  let data_str = 
    List.fold_left
      (fun acc x -> acc ^ (string_of_int x) ^ " ")
      ""
      data
  in
  Printf.printf "\nData: [%s]\n" (String.trim data_str);
  Printf.printf "Count: %d\n" (List.length data);
  
  (* Display statistics *)
  Printf.printf "\nMean (Average): %.2f\n" stats.mean;
  Printf.printf "Median (Middle Value): %.2f\n" stats.median;
  Printf.printf "Mode (Most Frequent): %d (appears %d time(s))\n" 
    stats.mode stats.mode_frequency;
  
  Printf.printf "%s\n\n" (String.make 50 '=')

(*
   Helper function to convert string list to int list
   Uses map for transformation
   @param str_list: list of strings
   @return: list of integers
*)
let string_list_to_int_list (str_list : string list) : int list =
  List.map int_of_string str_list

(*
   Read integer input from user
   @param n: number of integers to read
   @return: list of integers (immutable)
*)
let rec read_integers (n : int) : int list =
  if n <= 0 then
    []
  else
    let rec read_single_integer prompt =
      Printf.printf "%s" prompt;
      flush stdout;
      try
        int_of_string (read_line ())
      with Failure _ ->
        Printf.printf "Invalid input. Please enter an integer.\n";
        read_single_integer prompt
    in
    
    (* Read integers recursively, building immutable list *)
    let rec read_n_integers count acc =
      if count > n then
        List.rev acc  (* Reverse to maintain input order *)
      else
        let value = read_single_integer 
          (Printf.sprintf "  Element %d: " count) in
        read_n_integers (count + 1) (value :: acc)
    in
    read_n_integers 1 []

(*
   Get number of elements from user
   @return: number of integers
*)
let rec get_count () : int =
  Printf.printf "\nEnter the number of integers: ";
  flush stdout;
  try
    let n = int_of_string (read_line ()) in
    if n <= 0 then (
      Printf.printf "Invalid input. Please enter a positive number\n";
      get_count ()
    ) else
      n
  with Failure _ ->
    Printf.printf "Invalid input. Please enter a valid integer.\n";
    get_count ()



(*
   Main function to run the statistics calculator
   Simplified to direct input mode only
*)
let run_calculator () : unit =
  Printf.printf "=== Statistics Calculator Program ===\n\n";
  
  (* Get input from user *)
  let n = get_count () in
  Printf.printf "\nEnter %d integers:\n" n;
  let data = read_integers n in
  
  (* Calculate and print statistics *)
  let stats = calculate_all_statistics data in
  print_statistics data stats

(*
   Main entry point
*)
let () = run_calculator ()
