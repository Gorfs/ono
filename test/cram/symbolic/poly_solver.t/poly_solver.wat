(module
  (func $read_int (import "ono" "read_int") (result i32))
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))
  (func $print_i32 (import "ono" "print_i32") (param i32))

  (func $main
    ;; coefficients of the polynomial
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $d i32)
    ;; x that we solve for
    (local $x i32)
    ;; intermediate values
    (local $result i32)
    (local $i i32)

    call $read_int
    local.set $a
    call $read_int
    local.set $b
    call $read_int
    local.set $c
    call $read_int
    local.set $d

    ;; make x symbolic
    call $i32_symbol
    local.set $x

    ;; Compute a*x^3 + b*x^2 + c*x + d
    local.get $a
    local.get $x
    i32.mul           
    local.get $b
    i32.add           

    local.get $x
    i32.mul           
    local.get $c
    i32.add           

    local.get $x
    i32.mul           
    local.get $d
    i32.add           

    local.set $result 

    ;; Check if result == 0
    local.get $result
    i32.const 0
    i32.eq

    (if
      (then
        ;; A solution is possible, now we need to find the root

        i32.const -100   ;; begin of loop
        local.set $i

        (loop $search_loop
          ;; Check if x == i
          local.get $x
          local.get $i
          i32.eq

          (if
            (then
              ;; x == i -> result with i == 0, a root is found
              unreachable
            )
          )

          ;; Increment i
          local.get $i
          i32.const 1
          i32.add
          local.set $i

          ;; loop until i > 100
          local.get $i
          i32.const 100
          i32.le_s
          br_if $search_loop
        )
      )
    )
  )
  (start $main)
)