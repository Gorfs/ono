(module
    (func $print_i64 (import "ono" "print_i64") (param i64))
    (func $square (param $n i64) (result i64)
        local.get $n
        local.get $n
        i64.mul
    )
    (func $main
        i64.const 50_000
        call $square
        call $print_i64
    )
    (start $main)
)