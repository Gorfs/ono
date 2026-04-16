(module
    (func $print_i32 (import "ono" "print_i32") (param i32))
    (func $get_steps (import "ono" "get_steps") (result i32))
    (func $get_display_last(import "ono" "get_display_last") (result i32))
    
    (func $main
        call $get_steps
        call $print_i32
        call $get_display_last
        call $print_i32
    )
    (start $main)
)