type token =
  | INT of (int)
  | FLOAT of (float)
  | SYMBOL of (string)
  | BOOL of (bool)
  | BINOP of (Expr.binop)
  | PLUS
  | MINUS
  | PROD
  | DIV
  | RPAREN
  | LPAREN
  | EOF
  | UMINUS
  | EQ
  | LT
  | OR
  | AND
  | NOT
  | LET
  | IN
  | FUN
  | REC
  | ARROW
  | FUNTERM
  | IF
  | THEN
  | ELSE

val top :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.expr
