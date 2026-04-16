(module
  (import "ono" "read_int" (func $read_int (result i32)))
  (import "ono" "print_i32" (func $print_i32 (param i32)))
  (func $main
    call $read_int
    call $print_i32
  )
  (start $main)
)
