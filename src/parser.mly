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
%token LET IN FUN REC ARROW FUNTERM
%token IF THEN ELSE

%start top
%type <Expr.expr> top

%left LPAREN RPAREN
%left EQ LT OR AND NOT
%left PLUS MINUS
%left PROD DIV

%%

top:
| expr EOF { $1 };
  
expr:
| INT { Int $1 }
| FLOAT { Float $1 }
| SYMBOL { Symbol $1 }
| BOOL { Bool $1 }
| NOT expr { Not($2) }
| expr expr %prec LPAREN { Appl($1, $2) }
| LPAREN expr RPAREN { $2 }
| LET SYMBOL EQ expr IN expr { Decl($2, $4, $6) }
| LET SYMBOL EQ expr { Def($2, $4) }
| FUN SYMBOL ARROW expr { Fct($2, $4) }
| IF expr THEN expr ELSE expr { If($2, $4, $6) }
| expr PLUS expr { Binop (Plus, $1, $3) }
| expr MINUS expr { Binop (Minus, $1, $3) }
| MINUS INT { Int ((-1)*$2) }
| expr PROD expr { Binop (Prod, $1, $3) }
| expr DIV expr { Binop (Div, $1, $3) }
| expr EQ expr { Binop (Eq, $1, $3) }
| expr LT expr { Binop (Lt, $1, $3) }
| expr OR expr { Binop (Or, $1, $3) }
| expr AND expr { Binop (And, $1, $3) }
| expr BINOP expr { Binop ($2, $1, $3) }
| expr EQ expr { Binop(Eq, $1, $3) }
;
