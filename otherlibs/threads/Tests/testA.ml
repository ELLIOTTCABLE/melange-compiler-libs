let private_data = (Hashtbl.new 17 : (Thread.t, string) Hashtbl.t)
let private_data_lock = Mutex.new()

let set_private_data data =
  Mutex.lock private_data_lock;
  Hashtbl.add private_data (Thread.self()) data;
  Mutex.unlock private_data_lock

let get_private_data () =
  Hashtbl.find private_data (Thread.self())

let process id data =
  set_private_data data;
  print_int id; print_string " --> "; print_string(get_private_data());
  print_newline()

let _ =
  let t1 = Thread.new (process 1) "un" in
  let t2 = Thread.new (process 2) "deux" in
  let t3 = Thread.new (process 3) "trois" in
  let t4 = Thread.new (process 4) "quatre" in
  let t5 = Thread.new (process 5) "cinq" in
  List.iter Thread.join [t1;t2;t3;t4;t5]

