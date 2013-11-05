{
  open Parser
  open Expr
}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0' - '9']
let binop_symbols = "+" | "*" | "-" | "/" | "<" | ">" | "|" | ":" | "@" | "."

rule lex = parse
  | [' ' '\t' '\n'] {lex lexbuf}
  | '(' { LPAREN }
  | ')' { RPAREN }
  | "->" { ARROW }
  | '+' { PLUS }
  | '-' { MINUS }
  | '*' { PROD }
  | '/' { DIV }
  | '=' { EQ }
  | '<' { LT }
  | "and" { AND }
  | "or" { OR }
  | "-"? digit+ as n { INT(int_of_string n) }
  | "-"? digit+ "." digit* as f { FLOAT(float_of_string f) }
  | binop_symbols+ | "and" | "or" as op { BINOP(binop_of_string op) }
  | "fun" { FUN }
  | "rec" { REC }
  | "let" { LET }
  | "in" { IN }
  | ";;" { FUNTERM }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "not" { NOT }
  | "true" | "false" as s { BOOL(bool_of_string s) }
  | letter (letter | digit)*  as s { SYMBOL(s) }
  | eof { EOF }
