(module
    (func $print_cell (import "ono" "print_cell") (param i32))
    (func $newline (import "ono" "newline"))
    (func $clear_screen (import "ono" "clear_screen"))
    (func $sleep (import "ono" "sleep") (param i32))
    (func $loop
        i32.const 0
        call $clear_screen
        call $print_cell
        i32.const 1000
        call $sleep
        call $loop
    )
    (func $main
        call $loop
    )
    (start $main)
)
