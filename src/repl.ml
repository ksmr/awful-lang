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

let proto_env = Env (("id", (top lex (Lexing.from_string "fun x -> x"), Empty)), Empty)

let main () =
  try
    let s = ref "" in
    let buf = ref (Lexing.from_string "") in
    while true do
      print_string "> ";
      s.contents <- read_line ();
      buf.contents <- Lexing.from_string s.contents;
      try
	print_value (eval proto_env (top lex buf.contents))
      with
	  Wrong_args -> (print_string "ERROR: Argument(s) of wrong type"; print_newline ();)
	| Div_by_zero -> (print_string "ERROR: Division by zero"; print_newline ();)
    done;
  with _ -> failwith "Error??";;

main ();;
	
