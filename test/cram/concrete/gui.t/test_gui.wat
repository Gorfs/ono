(module  
    (func $cell_print (import "ono" "cell_print") (param i32))
    (func $newline (import "ono" "newline"))
    (func $clear_screen (import "ono" "clear_screen"))
    (func $main
        call $clear_screen
        i32.const 0
        call $cell_print
        call $newline
    )
    (start $main)
)