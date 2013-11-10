{
  open Parser
  open Expr
}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0' - '9']
let binop_symbols = "+" | "*" | "-" | "/" | "<" | ">" | "|" | ":" | "@" | "." | "&" | "$"

rule lex = parse
  | [' ' '\t' '\n' '\r'] {lex lexbuf}
  | '(' { LPAREN }
  | ')' { RPAREN }
  | "[" { LBRACKET }
  | "]" { RBRACKET }
  | "->" { ARROW }
  | '+' { PLUS }
  | '-' { MINUS }
  | '~' { UMINUS }
  | '*' { PROD }
  | '/' { DIV }
  | '=' { EQ }
  | '<' { LT }
  | "\"" { QUOTE }
  | "and" { AND }
  | "or" { OR }
  | digit+ as n { INT(int_of_string n) }
  | digit+ "." digit* as f { FLOAT(float_of_string f) }
  | binop_symbols+ | "and" | "or" as op { BINOP(binop_of_string op) }
  | "fun" { FUN }
  | "rec" { REC }
  | "let" { LET }
  | "in" { IN }
  | ";;" { TERMINATOR }
  | "," { COMMA }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "not" { NOT }
  | "true" | "false" as s { BOOL(bool_of_string s) }
  | (letter | "_") (letter | digit | "_")*   as s { SYMBOL(s) }
  | eof { EOF }
