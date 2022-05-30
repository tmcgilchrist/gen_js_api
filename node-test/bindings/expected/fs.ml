[@@@js.dummy "!! This code has been generated by gen_js_api !!"]
[@@@ocaml.warning "-7-32-39"]
module Dirent =
  struct
    type t = Ojs.t
    let rec t_of_js : Ojs.t -> t = fun (x2 : Ojs.t) -> x2
    and t_to_js : t -> Ojs.t = fun (x1 : Ojs.t) -> x1
    let (name : t -> string) =
      fun (x3 : t) ->
        Ojs.string_of_js (Ojs.get_prop_ascii (t_to_js x3) "name")
    let (is_file : t -> bool) =
      fun (x4 : t) -> Ojs.bool_of_js (Ojs.call (t_to_js x4) "isFile" [||])
    let (is_directory : t -> bool) =
      fun (x5 : t) ->
        Ojs.bool_of_js (Ojs.call (t_to_js x5) "isDirectory" [||])
  end
module Dir =
  struct
    type t = Ojs.t
    let rec t_of_js : Ojs.t -> t = fun (x7 : Ojs.t) -> x7
    and t_to_js : t -> Ojs.t = fun (x6 : Ojs.t) -> x6
    let (path : t -> string) =
      fun (x8 : t) ->
        Ojs.string_of_js (Ojs.get_prop_ascii (t_to_js x8) "path")
    let (close : t -> unit Promise.t) =
      fun (x9 : t) ->
        Promise.t_of_js Ojs.unit_of_js (Ojs.call (t_to_js x9) "close" [||])
    let (read : t -> Dirent.t option Promise.t) =
      fun (x11 : t) ->
        Promise.t_of_js
          (fun (x12 : Ojs.t) -> Ojs.option_of_js Dirent.t_of_js x12)
          (Ojs.call (t_to_js x11) "read" [||])
  end
module FileHandle =
  struct
    type t = Ojs.t
    let rec t_of_js : Ojs.t -> t = fun (x15 : Ojs.t) -> x15
    and t_to_js : t -> Ojs.t = fun (x14 : Ojs.t) -> x14
    type read = {
      bytes_read: int ;
      buffer: Buffer.t }
    let rec read_of_js : Ojs.t -> read =
      fun (x17 : Ojs.t) ->
        {
          bytes_read = (Ojs.int_of_js (Ojs.get_prop_ascii x17 "bytesRead"));
          buffer = (Buffer.t_of_js (Ojs.get_prop_ascii x17 "buffer"))
        }
    and read_to_js : read -> Ojs.t =
      fun (x16 : read) ->
        Ojs.obj
          [|("bytesRead", (Ojs.int_to_js x16.bytes_read));("buffer",
                                                            (Buffer.t_to_js
                                                               x16.buffer))|]
    let (append_file : t -> Buffer.t -> unit Promise.t) =
      fun (x19 : t) ->
        fun (x18 : Buffer.t) ->
          Promise.t_of_js Ojs.unit_of_js
            (Ojs.call (t_to_js x19) "appendFile" [|(Buffer.t_to_js x18)|])
    let (read : t -> Buffer.t -> int -> int -> int -> read Promise.t) =
      fun (x25 : t) ->
        fun (x21 : Buffer.t) ->
          fun (x22 : int) ->
            fun (x23 : int) ->
              fun (x24 : int) ->
                Promise.t_of_js read_of_js
                  (Ojs.call (t_to_js x25) "read"
                     [|(Buffer.t_to_js x21);(Ojs.int_to_js x22);(Ojs.int_to_js
                                                                   x23);(
                       Ojs.int_to_js x24)|])
    let (chmod : t -> int -> unit Promise.t) =
      fun (x28 : t) ->
        fun (x27 : int) ->
          Promise.t_of_js Ojs.unit_of_js
            (Ojs.call (t_to_js x28) "chmod" [|(Ojs.int_to_js x27)|])
    let (chmown : t -> uid:int -> gid:int -> unit Promise.t) =
      fun (x32 : t) ->
        fun ~uid:(x30 : int) ->
          fun ~gid:(x31 : int) ->
            Promise.t_of_js Ojs.unit_of_js
              (Ojs.call (t_to_js x32) "chmown"
                 [|(Ojs.int_to_js x30);(Ojs.int_to_js x31)|])
    let (close : t -> unit Promise.t) =
      fun (x34 : t) ->
        Promise.t_of_js Ojs.unit_of_js (Ojs.call (t_to_js x34) "close" [||])
    let (datasync : t -> unit Promise.t) =
      fun (x36 : t) ->
        Promise.t_of_js Ojs.unit_of_js
          (Ojs.call (t_to_js x36) "datasync" [||])
    let (fd : t -> int) =
      fun (x38 : t) -> Ojs.int_of_js (Ojs.get_prop_ascii (t_to_js x38) "fd")
  end
let (readdir : string -> string list Promise.t) =
  fun (x39 : string) ->
    Promise.t_of_js
      (fun (x40 : Ojs.t) -> Ojs.list_of_js Ojs.string_of_js x40)
      (Ojs.call (Ojs.get_prop_ascii Imports.fs "promises") "readdir"
         [|(Ojs.string_to_js x39)|])
let (open_ : string -> flag:string -> FileHandle.t Promise.t) =
  fun (x42 : string) ->
    fun ~flag:(x43 : string) ->
      Promise.t_of_js FileHandle.t_of_js
        (Ojs.call (Ojs.get_prop_ascii Imports.fs "promises") "open"
           [|(Ojs.string_to_js x42);(Ojs.string_to_js x43)|])
let (rmdir : string -> unit Promise.t) =
  fun (x45 : string) ->
    Promise.t_of_js Ojs.unit_of_js
      (Ojs.call (Ojs.get_prop_ascii Imports.fs "promises") "rmdir"
         [|(Ojs.string_to_js x45)|])
let (rename : string -> string -> unit Promise.t) =
  fun (x47 : string) ->
    fun (x48 : string) ->
      Promise.t_of_js Ojs.unit_of_js
        (Ojs.call (Ojs.get_prop_ascii Imports.fs "promises") "rename"
           [|(Ojs.string_to_js x47);(Ojs.string_to_js x48)|])
let (unlink : string -> unit Promise.t) =
  fun (x50 : string) ->
    Promise.t_of_js Ojs.unit_of_js
      (Ojs.call (Ojs.get_prop_ascii Imports.fs "promises") "unlink"
         [|(Ojs.string_to_js x50)|])
