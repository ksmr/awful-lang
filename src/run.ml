open Expr
open Eval
open Parser
open Lexer

let eval_file (env : env) (filename : string) : env =
  let fd = open_in filename in
  let buf = Lexing.from_channel fd in
  eval_list env print_value (top lex buf)

(*
let run (filename : string) : unit =
  ignore eval_file Empty filename *)
