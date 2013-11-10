COMPILER=ocamlc
YACC=ocamlyacc
LEX=ocamllex
SRC=src/
OPTS=-I $(SRC)

all: awful

awful: expr.cmo eval.cmo parser.cmo lexer.cmo repl.cmo run.cmo main.cmo
	$(COMPILER) $(OPTS) -o awful eval.cmo expr.cmo parser.cmo lexer.cmo repl.cmo run.cmo main.cmo

main.cmo:
	$(COMPILER) $(OPTS) -c $(SRC)/main.ml

run.cmo:
	$(COMPILER) $(OPTS) -c $(SRC)/run.ml

expr.cmo:
	$(COMPILER) $(OPTS) -c $(SRC)/expr.ml

repl.cmo: expr.cmo eval.cmo parser.cmo lexer.cmo
	$(COMPILER) $(OPTS) -c $(SRC)/repl.ml

eval.cmo: parser.cmo lexer.cmo expr.cmo
	$(COMPILER) $(OPTS) -c $(SRC)/eval.ml

lexer.cmo: expr.cmo parser.cmo lexer.ml
	$(COMPILER) $(OPTS) -c $(SRC)/lexer.ml

lexer.ml:
	$(LEX) $(SRC)/lexer.mll

parser.cmo: expr.cmo parser.cmi
	$(COMPILER) $(OPTS) -c $(SRC)parser.ml

parser.cmi: parser.mli
	$(COMPILER) $(OPTS) -c $(SRC)/parser.mli

parser.mli: expr.cmo
	$(YACC) $(SRC)/parser.mly
