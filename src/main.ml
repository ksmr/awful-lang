open Repl
open Run


let main () =
  let env = ref Eval.Empty in
  let len = Array.length Sys.argv in
  env.contents <- eval_file Eval.Empty "./std/std.aw";
  if len = 1
  then repl !env
  else (
    for i=1 to (len-1) do
      env.contents <- eval_file !env Sys.argv.(i);
    done;
  )

let _ = main ();;
