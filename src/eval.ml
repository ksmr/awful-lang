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

let rec eval (env : env ) (expr : expr) : value =
  match expr with
      Int n -> Vint n
    | Float f -> Vfloat f
    | Bool b -> Vbool b
    | Symbol x -> let (ep, ev) = value_of_symbol env x in
		  eval ev ep
    | Not e -> (match eval env e with
	Vbool b -> Vbool (not b)
	| _ -> raise Wrong_args )
    | Binop (op, e1, e2) -> (
      let res = (eval env e1, eval env e2) in
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
    )
    | If (e1, e2, e3) -> ( match eval env e1 with
	(Vbool true) -> eval env e2
	| (Vbool false) -> eval env e3 
	| _ -> raise Wrong_args )
    | Fct (arg, e) -> Vclosure (arg, e, env)
    | Appl (e1, e2) -> ( match eval env e1 with
	Vclosure (arg, ep, ev) ->
	  eval (Env ((arg, (e2, env)), ev)) ep )
    | Decl (sym, e1, e2) -> eval (Env ((sym, (e1, env)), env)) e2
