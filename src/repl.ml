open Expr
open Eval
open Parser
open Lexer


let repl (e : env) : unit =
  try
    let s = ref "" in
    let buf = ref (Lexing.from_string "") in
    let e = ref e in
    print_string "Awful interpreter, Ctrl+D exits\n";
    while true do
      print_string "> ";
      s.contents <- read_line ();
      buf.contents <- Lexing.from_string s.contents;
      try
(*
	ignore (List.map (fun e -> print_value (eval Empty e)) (top lex buf.contents)); *)
	e.contents <- eval_list !e print_value (top lex buf.contents);
      with
	  Wrong_args -> print_string "ERROR: Argument(s) of wrong type\n"; 
	| Div_by_zero -> print_string "ERROR: Division by zero\n";
	| Undefined s -> print_string ("ERROR: Undefined '" ^ s ^ "'\n");
	| Parsing.Parse_error -> print_string ("PARSE ERROR\n");
    done;
  with End_of_file -> print_newline (); exit 1;
    |_ -> failwith "Error??";;
	
