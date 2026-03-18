(module
  (func $get_steps (import "ono" "get_steps") (result i32))
  (func $cell_print (import "ono" "cell_print") (param i32))
  (func $newline (import "ono" "newline"))
  (func $clear_screen (import "ono" "clear_screen"))
  (func $sleep (import "ono" "sleep") (param i32))

  (func $main (local $steps i32) (local $i i32)
    call $get_steps
    local.set $steps
    i32.const 0
    local.set $i
    (block $break
      (loop $loop
        local.get $i
        local.get $steps
        i32.ge_s
        br_if $break
        call $clear_screen
        i32.const 1
        call $cell_print
        i32.const 0
        call $cell_print
        call $newline
        i32.const 100
        call $sleep
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $loop))
  )
  (start $main)
)