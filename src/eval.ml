open Expr

type env = Empty
	   | Env of ( (string* (expr*env)) *env)

type value = Vint of int
	     | Vfloat of float
	     | Vbool of bool
	     | Vclosure of string*expr*env

type eval_action = Change_env of (string*(expr*env))
		   | Return_val of value

exception Undefined of string
exception Wrong_args
exception Div_by_zero

let rec value_of_symbol (ev : env) (x : string) : (expr*env) =
  match ev with
      Empty -> raise (Undefined x)
    | Env ((name, g), next) -> if name = x then g else value_of_symbol next x

let eval_binop ((op, res) : (binop*(value*value))) =
  match op with
      Plus -> ( match res with
	  (Vint n1, Vint n2) -> Vint (n1 + n2)
	| (Vfloat f1, Vfloat f2) -> Vfloat (f1 +. f2)
	| _ -> raise Wrong_args )
    | Minus -> ( match res with
	(Vint n1, Vint n2) -> Vint (n1 - n2)
	| (Vfloat f1, Vfloat f2) -> Vfloat (f1 -. f2) 
	| _ -> raise Wrong_args ) 
    | Prod -> ( match res with
	(Vint n1, Vint n2) -> Vint (n1 * n2) 
	| (Vfloat f1, Vfloat f2) -> Vfloat (f1 *. f2)
	| _ -> raise Wrong_args )
    | Div -> ( match res with
	(Vint n1, Vint n2) -> 
	  if n2 <> 0 
	  then Vint (n1 / n2) 
	  else raise Div_by_zero
	| (Vfloat f1, Vfloat f2) -> 
	  if f2 <> 0.
	  then Vfloat (f1 /. f2)
	  else raise Div_by_zero
	| _ -> raise Wrong_args )
    | Eq -> ( match res with
	(Vint n1, Vint n2) -> Vbool (n1 = n2)
	    | (Vfloat f1, Vfloat f2) -> Vbool (f1 = f2)
	    | (Vbool b1, Vbool b2) -> Vbool (b1 = b2)
	    | _ -> raise Wrong_args )
    | Lt -> ( match res with
	(Vint n1, Vint n2) -> Vbool (n1 < n2)
	| (Vfloat f1, Vfloat f2) -> Vbool (f1 < f2)
	| _ -> raise Wrong_args )
    | And -> ( match res with
	    (Vbool b1, Vbool b2) -> Vbool (b1 && b2)
	| _ -> raise Wrong_args )
    | Or -> ( match res with
	(Vbool b1, Vbool b2) -> Vbool (b1 || b2)
	| _ -> raise Wrong_args )


let rec eval (env : env ) (expr : expr) =
  match expr with
      Int n -> Return_val (Vint n)
    | Float f -> Return_val (Vfloat f)
    | Bool b -> Return_val (Vbool b)
    | Symbol x -> let (ep, ev) = value_of_symbol env x in
		  eval ev ep
    | Not e -> (match eval env e with
	Return_val (Vbool b) -> Return_val (Vbool (not b))
	| _ -> raise Wrong_args )
    | Binop (op, e1, e2) -> (let (Return_val r1, Return_val r2) = (eval env e1, eval env e2) in
			     match op with
			       | Custom s -> eval env (Appl(Appl(Symbol s, e1), e2))
			       | _ -> Return_val (eval_binop (op, (r1, r2))))
    | If (e1, e2, e3) -> ( match eval env e1 with
	Return_val (Vbool true) -> eval env e2
	| Return_val (Vbool false) -> eval env e3 
	| _ -> raise Wrong_args )
    | Fct (arg, e) -> Return_val (Vclosure (arg, e, env))
    | Fctrec (sym, arg, e) -> let new_env = Env ((sym, (Fctrec (sym, arg, e), env)), env) in
			      Return_val (Vclosure (arg, e, new_env))
    | Appl (e1, e2) -> ( match eval env e1 with
	Return_val (Vclosure (arg, ep, ev)) ->
	  eval (Env ((arg, (e2, env)), ev)) ep )
    | Decl (sym, e1, e2) -> eval (Env ((sym, (e1, env)), env)) e2
    | Declrec (sym, e1, e2) -> (
      match e1 with
	  Fct (arg, e) -> eval (Env ((sym, (Fctrec(sym, arg, e), env)), env)) e2
	| _ -> raise Wrong_args )
    | Def (sym, e) -> Change_env (sym, (e, env))
    | Defrec (sym, e) -> (
      match e with
	  Fct (arg, ex) -> Change_env (sym, (Fctrec (sym,arg,ex), env))
	| _ -> raise Wrong_args
    )

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


let rec eval_list (env : env) (handler : value -> unit) (l : expr list) : env =
  match l with
      [] -> env
    | e::t -> match eval env e with
	Return_val v -> ( handler v;
			  eval_list env handler t )
	| Change_env g -> eval_list (Env (g, env)) handler t
