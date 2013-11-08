open Expr;;
open Eval;;
open Parser;;
open Lexer;;

let print_value (v : value) : unit =
  print_string "==> ";
  match v with
      (Vint i) -> ( print_int i;
		    print_newline ();
       )
    | (Vbool b) -> ( print_string (string_of_bool b);
		     print_newline ();
    )
    | (Vfloat f) -> ( print_float f;
		      print_newline ();
    )
    | (Vclosure (arg, exp, env)) -> ( print_string "function";
				      print_newline ();
    )
    | _ -> print_newline ();;

(* let proto_env = Env (("id", (top lex (Lexing.from_string "fun x -> x"), Empty)), Empty) *)

let rec eval_list (env : env) (l : expr list) : env =
  match l with
      [] -> env
    | e::t -> match eval env e with
	Return_val v -> ( print_value v;
			  eval_list env t )
	| Change_env g -> eval_list (Env (g, env)) t

let main () =
  try
    let s = ref "" in
    let buf = ref (Lexing.from_string "") in
    let e = ref Empty in
    while true do
      print_string "> ";
      s.contents <- read_line ();
      buf.contents <- Lexing.from_string s.contents;
      try
(*
	ignore (List.map (fun e -> print_value (eval Empty e)) (top lex buf.contents)); *)
	e.contents <- eval_list !e (top lex buf.contents);
      with
	  Wrong_args -> print_string "ERROR: Argument(s) of wrong type\n"; 
	| Div_by_zero -> print_string "ERROR: Division by zero\n";
	| Undefined s -> print_string ("ERROR: Undefined '" ^ s ^ "'\n");
    done;
  with _ -> failwith "Error??";;

main ();;
	
