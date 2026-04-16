(module
  (import "ono" "clear_screen" (func $clear_screen))
  (import "ono" "read_int" (func $read_int (result i32)))
  (import "ono" "print_cell" (func $print_cell (param i32)))
  (import "ono" "newline" (func $newline))
  (import "ono" "sleep" (func $sleep (param i32)))

  (func $main
    call $clear_screen
    call $read_int
    call $print_cell
    call $newline
    i32.const 1000
    call $sleep
  )

  (start $main)
)
