(* The gen_js_api is released under the terms of an MIT-like license.     *)
(* See the attached LICENSE file.                                         *)
(* Copyright 2015 by LexiFi.                                              *)

(* This module (mostly) abstracts away from js_of_ocaml encoding of
   OCaml values.  It serves as a support library for the code generated
   by gen_js_api.

   The module could mostly be implemented on top of js_of_ocaml's Js module
   (and in particular Js.Unsafe), but we prefer to drop the dependency
   to js_of_ocaml's library and to rely only on its compiler and JS
   runtime code.
*)


type t

external t_of_js: t -> t = "%identity"
external t_to_js: t -> t = "%identity"

external string_of_js: t -> string = "caml_js_to_string"
external string_to_js: string -> t = "caml_js_from_string"

external int_of_js: t -> int = "%identity"
external int_to_js: int -> t = "%identity"

external bool_of_js: t -> bool = "caml_js_to_bool"
external bool_to_js: bool -> t = "caml_js_from_bool"

external float_of_js: t -> float = "%identity"
external float_to_js: float -> t = "%identity"

external obj: (string * t) array -> t = "caml_js_object"

external variable: string -> t = "caml_js_var"

external get: t -> string -> t = "caml_js_get"
external set: t -> string -> t -> unit = "caml_js_set"
external delete: t -> string -> unit = "caml_js_delete"

external get_prop: t -> t -> t = "caml_js_get"
external set_prop: t -> t -> t -> unit = "caml_js_set"
external delete_prop: t -> t -> unit = "caml_js_delete"

external get_prop_ascii: t -> string -> t = "caml_js_get"
external set_prop_ascii: t -> string -> t -> unit = "caml_js_set"
external delete_prop_ascii: t -> string -> unit = "caml_js_delete"

external internal_type_of: t -> t = "caml_js_typeof"
let type_of x = string_of_js (internal_type_of x)

external internal_instance_of: t -> t -> t = "caml_js_instanceof"
let instance_of x ~constr = bool_of_js (internal_instance_of x constr)

external pure_js_expr: string -> t = "caml_pure_js_expr"
let null = pure_js_expr "null"
let undefined = pure_js_expr "undefined"

external equals: t -> t -> bool = "caml_js_equals"

let global = pure_js_expr "joo_global_object"

external new_obj: t -> t array -> t = "caml_js_new"

external call: t -> string -> t array -> t = "caml_js_meth_call"
external apply: t -> t array -> t = "caml_js_fun_call"

let array_make n = new_obj (get_prop_ascii global "Array") [|int_to_js n|]
let array_get t i = get_prop t (int_to_js i)
let array_set t i x = set_prop t (int_to_js i) x

let array_of_js_from f objs start =
  let n = int_of_js (get_prop_ascii objs "length") in
  Array.init (n - start) (fun i -> f (array_get objs (start + i)))

let array_of_js f objs = array_of_js_from f objs 0

let array_to_js f arr =
  let n = Array.length arr in
  let a = array_make n in
  for i = 0 to n - 1 do
    array_set a i (f arr.(i))
  done;
  a

let list_of_js_from f objs start = Array.to_list (array_of_js_from f objs start)

let list_of_js f objs = list_of_js_from f objs 0

let list_to_js f l =
  array_to_js f (Array.of_list l)

let option_of_js f x =
  if equals x null || x == undefined then None
  else Some (f x)

let option_to_js f = function
  | Some x -> f x
  | None -> null

let unit_to_js () = undefined
let unit_of_js _ = ()

class obj (x:t) =
  object
    method to_js = x
  end

external fun_to_js: int -> (t -> 'a) -> t = "caml_js_wrap_callback_strict"
external fun_to_js_args: (t -> 'a) -> t = "caml_ojs_wrap_fun_arguments"

let has_property o x =
  type_of o = "object" && o != null
  && get_prop o (string_to_js x) != undefined

external new_obj_arr: t -> t -> t = "caml_ojs_new_arr"

let empty_obj () = new_obj (get_prop_ascii global "Object") [||]

external iter_properties: t -> (string -> unit) -> unit = "caml_ojs_iterate_properties"
let apply_arr o arr = call o "apply" [| null; arr |]
let call_arr o s arr = call (get_prop o (string_to_js s)) "apply" [| o; arr |]

let is_null x =
  equals x null

let obj_type x =
  string_of_js (call (pure_js_expr "Object.prototype.toString") "call" [|x|])

module type T = sig
  type js := t
  type t
  val t_to_js : t -> js
  val t_of_js : js -> t
end

(* Ojs.T instances for built-in types *)
module Int = struct
  type t = int
  let t_to_js = int_to_js
  let t_of_js = int_of_js
 end
module String = struct
  type t = string
  let t_to_js = string_to_js
  let t_of_js = string_of_js
end
module Bool = struct
  type t = bool
  let t_to_js = bool_to_js
  let t_of_js = bool_of_js
end
module Float = struct
  type t = float
  let t_to_js = float_to_js
  let t_of_js = float_of_js
end
module Array (A: T) = struct
  type t = A.t array
  let t_to_js = array_to_js A.t_to_js
  let t_of_js = array_of_js A.t_of_js
end
module List (A: T) = struct
  type t = A.t list
  let t_to_js = list_to_js A.t_to_js
  let t_of_js = list_of_js A.t_of_js
end
module Option (A: T) = struct
  type t = A.t option
  let t_to_js = option_to_js A.t_to_js
  let t_of_js = option_of_js A.t_of_js
end
