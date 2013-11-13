%{
  open Expr
%}

%token <int> INT
%token <float> FLOAT
%token <string> SYMBOL
%token <bool> BOOL
%token <Expr.binop> BINOP
%token PLUS MINUS PROD DIV RPAREN LPAREN EOF UMINUS
%token EQ LT OR AND NOT
%token LET IN FUN REC ARROW TERMINATOR
%token IF THEN ELSE
%token QUOTE RBRACKET LBRACKET COMMA

%start top
%type <Expr.expr list> top
%type <Expr.expr> expr

%left LPAREN RPAREN
%left EQ LT OR AND NOT
%left PLUS MINUS
%left PROD DIV
%left BINOP
%left APPLY

%%

top: 
| EOF { [] }
| expr TERMINATOR EOF { [$1] }
| expr TERMINATOR top { $1::$3 }
| expr EOF { [$1] }
;
  
expr:
| LPAREN expr RPAREN { $2 }
| LET SYMBOL EQ expr IN expr { Decl($2, $4, $6) }
| LET REC SYMBOL EQ expr IN expr { Declrec($3, $5, $7) }
| LET SYMBOL EQ expr { Def($2, $4) }
| LET REC SYMBOL EQ expr { Defrec($3, $5) }
| LET BINOP EQ expr IN expr { let Custom s = $2 in Decl (s, $4, $6) }
| LET BINOP EQ expr { let Custom s = $2 in Def (s, $4) }
| FUN args ARROW expr { List.fold_left (fun e x -> Fct(x, e)) (Fct(List.hd $2, $4)) (List.tl $2) }
| IF expr THEN expr ELSE expr { If($2, $4, $6) }
| MINUS INT { Int ((-1)*$2) }
| bool_op { $1 }
| expr PLUS expr { Binop (Plus, $1, $3) }
| expr MINUS expr { Binop (Minus, $1, $3) }
| expr PROD expr { Binop (Prod, $1, $3) }
| expr DIV expr { Binop (Div, $1, $3) }
| expr EQ expr { Binop (Eq, $1, $3) }
| expr LT expr { Binop (Lt, $1, $3) }
| expr BINOP expr { Binop ($2, $1, $3) }
| non_app { $1 }
| apply { $1 }
;

apply:
| apply non_app { Appl($1, $2) }
| non_app non_app { Appl($1, $2) }

args:
| args SYMBOL { $2::$1 }
| SYMBOL { [$1] }

non_app:
| SYMBOL { Symbol $1 }
| INT { Int $1 }
| FLOAT { Float $1 }
| BOOL { Bool $1 }
| LPAREN expr RPAREN { $2 }

bool_op:
| NOT expr { Not($2) }
| expr OR expr { Binop (Or, $1, $3) }
| expr AND expr { Binop (And, $1, $3) }

