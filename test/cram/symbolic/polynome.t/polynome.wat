(module
  ;; WE import the "ono" module which provides the necessary functions for symbolic execution, like the read_int
  (func $read_int (import "ono" "read_int") (result i32))
  (func $symbol_int (import "ono" "i32_symbol") (result i32))

  (func $main
    ;; The variables for the coefficients, the symbolic variable, the polynomial result, and the loop counter
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $d i32)
    (local $x i32)
    (local $poly i32)
    (local $i i32)

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

    ;; Save the result in $poly
    local.set $poly

    ;; Check if the result is equal to 0
    local.get $poly
    i32.const 0
    i32.eq

    ;; If the poly is equal to 0 we have found a root.
    ;; We use a loop to force the symbolic engine to explore multiple paths and find ALL integer roots.
    (if
      (then
        ;; Initialize loop counter i = -100
        i32.const -100
        local.set $i

        (loop $search
          ;; Check if x == i
          local.get $x
          local.get $i
          i32.eq
          (if
            (then
              ;; The engine will branch here and crash if x is a root equal to i
              unreachable
            )
          )

          ;; Increment i: i = i + 1
          local.get $i
          i32.const 1
          i32.add
          local.set $i

          ;; Continue loop if i <= 100
          local.get $i
          i32.const 100
          i32.le_s
          br_if $search
        )
      )
    )
  )
  (start $main)
)
