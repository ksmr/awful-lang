let <> = fun a b -> not (a = b);;
let <= = fun a b -> (a = b) or (a < b);;
let > = fun a b -> not (a <= b);;
let >= = fun a b -> not (a < b);;