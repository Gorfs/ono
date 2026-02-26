(module
  ;; WE import the "ono" module which provides the necessary functions for symbolic execution, like the read_int
  (func $read_int (import "ono" "read_int") (result i32))
  (func $symbol_int (import "ono" "i32_symbol") (result i32))

  (func $main
    ;; THe wariable for the coefficients and the symbolic variable
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $d i32)
    (local $x i32)

    ;; REad the coefficients a, b, c, d from the user
    call $read_int
    local.set $a
    call $read_int
    local.set $b
    call $read_int
    local.set $c
    call $read_int
    local.set $d

    ;; create a symbolic variable x
    call $symbol_int
    local.set $x

    ;; CalCulate the value of the polynomial ax^3 + bx^2 + cx + d

    local.get $a
    local.get $x
    i32.mul         ;; a * x

    local.get $b
    i32.add         ;; (a * x) + b

    local.get $x
    i32.mul         ;; ((a * x) + b) * x  => ax^2 + bx

    local.get $c
    i32.add         ;; ax^2 + bx + c

    local.get $x
    i32.mul         ;; (ax^2 + bx + c) * x => ax^3 + bx^2 + cx

    local.get $d
    i32.add         ;; ax^3 + bx^2 + cx + d

    ;; Check if the result is equal to 0
    i32.const 0
    i32.eq

    ;; If the plly is equal to 0 we have found a root, which is a failure case for this test, so we call unreachable
    (if
      (then
        unreachable
      )
    )
  )
  (start $main)
)
