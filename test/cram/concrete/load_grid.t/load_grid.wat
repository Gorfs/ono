(module
  (func $print_cell (import "ono" "print_cell") (param i32))
  (func $newline    (import "ono" "newline"))
  (func $get_grid_cell (import "ono" "get_grid_cell") (param i32) (result i32))

  (global $WIDTH i32 (i32.const 8))
  (global $HEIGHT i32 (i32.const 8))

  (memory (export "memory") 1)

  (func $coord_to_index (param $i i32) (param $j i32) (result i32)
    (i32.add
      (i32.mul (local.get $i) (global.get $WIDTH))
      (local.get $j)
    )
  )

  (func $print_grid
    (local $i i32)
    (local $j i32)
    (local $idx i32)
    (local $cell i32)
    (local.set $i (i32.const 0))
    (block $break_i
      (loop $loop_i
        (local.set $j (i32.const 0))
        (block $break_j
          (loop $loop_j
            (local.set $idx (call $coord_to_index (local.get $i) (local.get $j)))
            (local.set $cell (call $get_grid_cell (local.get $idx)))
            (call $print_cell (local.get $cell))
            (local.set $j (i32.add (local.get $j) (i32.const 1)))
            (br_if $loop_j (i32.lt_s (local.get $j) (global.get $WIDTH)))
          )
          (call $newline)
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $loop_i (i32.lt_s (local.get $i) (global.get $HEIGHT)))
      )
    )
  )

  (func $main
    (call $print_grid)
  )
  (start $main)
)