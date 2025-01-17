open Graphics

type point = { x : int; y : int }
type line = { a : point; b : point }
type rectangle = { c : point; length : int; width : int }
type circle = { c : point; radius : int }
type ellipse = {c : point; rx : int; ry: int}
type shape = Circle of circle | Rectangle of rectangle | Ellipse of ellipse | Line of line
type shapes = shape list

let dimensions = ref {x = 500; y = 500}
let set_dimensions x y = 
  dimensions := {x;y} 

let canvas_mid = { x = (!dimensions.x / 2); y = (!dimensions.y / 2)}

let axes_flag = ref false
let draw_axes flag = 
  axes_flag := flag

let draw_line x1 y1 x2 y2 = 
  draw_poly_line [|(x1, y1); (x2, y2)|]

let render_shape s =
  match s with
  | Circle circle -> draw_circle circle.c.x circle.c.y circle.radius
  | Rectangle rectangle ->
      draw_rect rectangle.c.x rectangle.c.y rectangle.length rectangle.width
  | Ellipse ellipse ->
    draw_ellipse ellipse.c.x ellipse.c.y ellipse.rx ellipse.ry
  | Line line -> draw_line line.a.x line.a.y line.b.x line.b.y

let circle ?x ?y r =
  match (x, y) with
  | Some x, Some y -> Circle { c = { x; y }; radius = r }
  | _ -> Circle { c = { x = canvas_mid.x; y = canvas_mid.y }; radius = r }

let rectangle ?x ?y length width =
  
  match (x, y) with
  | Some x, Some y -> Rectangle { c = { x; y }; length; width }
  | _ -> Rectangle { c = { x = canvas_mid.x; y = canvas_mid.y }; length; width }

let ellipse ?x ?y rx ry =
  match (x, y) with
  | Some x, Some y -> Ellipse {c = {x; y}; rx; ry}
  | _ -> Ellipse {c = { x = canvas_mid.x; y = canvas_mid.y}; rx; ry}

let line ?x1 ?y1 x2 y2 =
  match (x1, y1) with 
  | Some x, Some y -> Line {a = {x;y}; b = {x = x2; y = y2}}
  | _ -> Line {a = canvas_mid; b = {x = x2; y = y2}}
  
let translate dx dy shape =
  match shape with
  | Circle circle -> Circle { circle with c = { x = circle.c.x + dx; y = circle.c.y + dy } }
  | Rectangle rectangle -> Rectangle { rectangle with c = { x = rectangle.c.x + dx; y = rectangle.c.y + dy } }
  | Ellipse ellipse -> Ellipse { ellipse with c = { x = ellipse.c.x + dx; y = ellipse.c.y + dy } }
  | Line line -> Line {a = {x = line.a.x + dx; y = line.a.y + dy}; b = {x = line.b.x + dx; y = line.b.y + dy}}

let show shapes = List.iter render_shape shapes

let render_axes () = 
  set_color (rgb 192 192 192);
  let half_x = (size_x ()) / 2 in 
  draw_line half_x 0 half_x (size_y ());
  let half_y = (size_y ()) / 2 in 
  draw_line 0 half_y (size_x ()) half_y

let init () =
  open_graph (Printf.sprintf " %ix%i" !dimensions.x !dimensions.y);
  if !axes_flag then
    render_axes ();
    
  set_color black

let close () =
  ignore (read_line ());
  close_graph ()