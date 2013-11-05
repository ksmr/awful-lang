COMPILER=ocamlc
YACC=ocamlyacc
LEX=ocamllex

all: picoML

picoML: eval.cmo expr.cmo parser.cmo lexer.cmo repl.cmo
	$(COMPILER) -o picoML eval.cmo expr.cmo parser.cmo lexer.cmo repl.cmo

expr.cmo:
	$(COMPILER) -c expr.ml

repl.cmo: eval.cmo parser.cmo lexer.cmo
	$(COMPILER) -c repl.ml

eval.cmo: parser.cmo lexer.cmo
	$(COMPILER) -c eval.ml

lexer.cmo: lexer.ml
	$(COMPILER) -c lexer.ml

lexer.ml:
	$(LEX) lexer.mll

parser.cmo: parser.cmi
	$(COMPILER) -c parser.ml

parser.cmi: parser.mli expr.cmo
	$(COMPILER) -c parser.mli

parser.mli:
	$(YACC) parser.mly
