type binop = Plus
	     | Minus
	     | Prod
	     | Div
	     | Eq
	     | Lt
	     | Or
	     | And
	     | Custom of string

type expr = Int of int
	    | Float of float
	    | Bool of bool
	    | Symbol of string
	    | Decl of string*expr*expr
	    | Declrec of string*expr*expr
	    | Def of string*expr
	    | Defrec of string*expr
	    | Not of expr
	    | Binop of binop*expr*expr
	    | If of expr*expr*expr
	    | Fct of string*expr
	    | Fctrec of string*string*expr
	    | Appl of expr*expr

       
let binop_of_string (s : string) : binop =
  match s with
      "+" -> Plus
    | "-" -> Minus
    | "*" -> Prod
    | "/" -> Div
    | "and" -> And
    | "=" -> Eq
    | "or" -> Or
    | "<" -> Lt
    | _ -> Custom s
