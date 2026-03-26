(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))

  (global $WIDTH i32 (i32.const 3))
  (global $HEIGHT i32 (i32.const 3))

  (memory (export "memory") 1)


  (func $coord_to_index (param $i i32) (param $j i32) (result i32)
    (local $temp i32)
    (local.set $temp (i32.mul (local.get $i) (global.get $WIDTH)))
    (local.set $temp (i32.add (local.get $temp) (local.get $j)))
    (local.get $temp)
  )

  (func $is_alive (param $i i32) (param $j i32) (result i32)
    (local $coord i32)
    (if (i32.lt_s (local.get $i) (i32.const 0))
      (then (return (i32.const 0))))
    (if (i32.ge_s (local.get $i) (global.get $HEIGHT))
      (then (return (i32.const 0))))
    (if (i32.lt_s (local.get $j) (i32.const 0))
      (then (return (i32.const 0))))
    (if (i32.ge_s (local.get $j) (global.get $WIDTH))
      (then (return (i32.const 0))))
    (local.set $coord (call $coord_to_index (local.get $i) (local.get $j)))
    (return (i32.load8_u (local.get $coord)))
  )


  (func $count_neighbours (param $i i32) (param $j i32) (result i32)
    (local $count i32)
    (local $x i32)
    (local $y i32)
    (local $idx i32)
    (local.set $count (i32.const 0))
    (local.set $idx (i32.const 0))
    (block $break
      (loop $continue
        (if (i32.eq (local.get $idx) (i32.const 0))
          (then
            (local.set $x (i32.const -1))
            (local.set $y (i32.const -1))
          )
        )
        (if (i32.eq (local.get $idx) (i32.const 1))
          (then
            (local.set $x (i32.const -1))
            (local.set $y (i32.const 0))
          )
        )
        (if (i32.eq (local.get $idx) (i32.const 2))
          (then
            (local.set $x (i32.const -1))
            (local.set $y (i32.const 1))
          )
        )
        (if (i32.eq (local.get $idx) (i32.const 3))
          (then
            (local.set $x (i32.const 0))
            (local.set $y (i32.const -1))
          )
        )
        (if (i32.eq (local.get $idx) (i32.const 4))
          (then
            (local.set $x (i32.const 0))
            (local.set $y (i32.const 1))
          )
        )

        (if (i32.eq (local.get $idx) (i32.const 5))
          (then
            (local.set $x (i32.const +1))
            (local.set $y (i32.const -1))
          )
        )

        (if (i32.eq (local.get $idx) (i32.const 6))
          (then
            (local.set $x (i32.const +1))
            (local.set $y (i32.const 0))
          )
        )

        (if (i32.eq (local.get $idx) (i32.const 7))
          (then
            (local.set $x (i32.const +1))
            (local.set $y (i32.const +1))
          )
        )

        (local.set $count
          (i32.add
            (local.get $count)
            (call $is_alive
              (i32.add (local.get $i) (local.get $x))
              (i32.add (local.get $j) (local.get $y)))))
        (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
        (br_if $continue (i32.lt_s (local.get $idx) (i32.const 8)))
      )
    )
    (local.get $count)
  )


  (func $init_grid
    (local $i i32)
    (local $j i32)
    (local $index i32)
    (local $cell_symbolic i32)
    (local $cell i32)

    (local.set $i (i32.const 0))

    (block $break_i
      (loop $continue_i

      (local.set $j (i32.const 0))
        (block $break_j
          (loop $continue_j

          (local.set $index (call $coord_to_index (local.get $i) (local.get $j)))
          call $i32_symbol
          local.set $cell_symbolic
          (local.set $cell_symbolic
            (i32.rem_u (local.get $cell_symbolic) (i32.const 2))
          )
          (i32.store8 (local.get $index) (local.get $cell_symbolic))
          (local.set $j (i32.add (local.get $j) (i32.const 1)))
          (br_if $continue_j (i32.lt_s (local.get $j) (global.get $WIDTH)))
          )
        )

      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $continue_i (i32.lt_s (local.get $i) (global.get $HEIGHT)))
      )
    )
  )

  (func $step
    (local $i i32)
    (local $j i32)
    (local $index i32)
    (local $cell_alive i32)
    (local $neighbours i32)
    (local $new_state i32)
    (local $nb_rand i32)
    (local.set $i (i32.const 0))

    (block $break_i
      (loop $continue_i
        (local.set $j (i32.const 0))
        (block $break_j
          (loop $continue_j
            (local.set $index (call $coord_to_index (local.get $i) (local.get $j)))
            (local.set $neighbours (call $count_neighbours (local.get $i) (local.get $j)))
            (if (call $is_alive (local.get $i) (local.get $j))
              (then
                (if (i32.or (i32.lt_s (local.get $neighbours) (i32.const 2)) (i32.gt_s (local.get $neighbours) (i32.const 3)))
                  (then (local.set $cell_alive (i32.const 0)))
                  (else (local.set $cell_alive (i32.const 1)))
                )
              )
              (else
                (if (i32.eq (local.get $neighbours) (i32.const 3))
                  (then (local.set $cell_alive (i32.const 1)))
                  (else (local.set $cell_alive (i32.const 0)))
                )
              )
            )
            (i32.store8
              (i32.add (local.get $index) (i32.const 4500))  ;; écrire dans un buffer temporaire
              (local.get $cell_alive))
            (local.set $j (i32.add (local.get $j) (i32.const 1)))
            (br_if $continue_j (i32.lt_s (local.get $j) (global.get $WIDTH)))
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_i (i32.lt_s (local.get $i) (global.get $HEIGHT)))
      )
    )
    (local.set $i (i32.const 0))
    (block $break_copy
      (loop $continue_copy
        (i32.store8
          (local.get $i)
          (i32.load8_u (i32.add (local.get $i) (i32.const 4500))))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_copy (i32.lt_s (local.get $i) (i32.mul (global.get $WIDTH) (global.get $HEIGHT))))
      )
    )
  )


  (func $propriete1 (export "propriete1")
    (local $i i32)
    (local.set $i (i32.const 0))
    (call $init_grid)
    (call $step)
    (call $is_alive (i32.const 1) (i32.const 1))
    (if (then
      unreachable
    ) (else
      return
    ))
  )

  (func $propriete2 (export "propriete2")
    (local $i i32)
    (local $j i32)
    (local $found i32)
    (local $alive1 i32)
    (local $alive2 i32)
    (local $alive3 i32)
    (local $alive4 i32)

    (local.set $i (i32.const 0))
    (local.set $found (i32.const 0))
    (call $init_grid)
    (call $step)

    ;; une boucle qui vérifie si il y a quelque part un carré de 2x2 vivant
    (block $break_i
      (loop $continue_i
        (local.set $j (i32.const 0))
        (block $break_j
          (loop $continue_j
            (local.set $alive1 (call $is_alive (local.get $i) (local.get $j)))
            (local.set $alive2 (call $is_alive (i32.add (local.get $i) (i32.const 1)) (local.get $j)))
            (local.set $alive3 (call $is_alive (local.get $i) (i32.add (local.get $j) (i32.const 1))))
            (local.set $alive4 (call $is_alive (i32.add (local.get $i) (i32.const 1)) (i32.add (local.get $j) (i32.const 1))))

            (if (i32.and (i32.and (local.get $alive1) (local.get $alive2)) (i32.and (local.get $alive3) (local.get $alive4)))
              (then
                (local.set $found (i32.const 1))
              )
            )

            (local.set $j (i32.add (local.get $j) (i32.const 1)))
            (br_if $continue_j (i32.lt_s (local.get $j) (i32.sub (global.get $WIDTH) (i32.const 1))))
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_i (i32.lt_s (local.get $i) (i32.sub (global.get $HEIGHT) (i32.const 1))))
      )
    )

    (local.get $found)
    (if (then
      unreachable
    ) (else
      return
    ))
  )

  (func $propriete3 (export "propriete3")
    (local $i i32)
    (local $len i32)
    (local $matched i32)
    (local $changed i32)

    (call $init_grid)

    ;; Save original grid at offset 2000
    (local.set $i (i32.const 0))
    (local.set $len (i32.mul (global.get $WIDTH) (global.get $HEIGHT)))
    (block $break_save
      (loop $continue_save
        (i32.store8
          (i32.add (local.get $i) (i32.const 2000))
          (i32.load8_u (local.get $i))
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_save (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    ;; 1st step
    (call $step)

    ;; Save intermediate grid at offset 3000 to check if it actually changed
    (local.set $i (i32.const 0))
    (block $break_save_inter
      (loop $continue_save_inter
        (i32.store8
          (i32.add (local.get $i) (i32.const 3000))
          (i32.load8_u (local.get $i))
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_save_inter (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    ;; Check if it changed after the 1st step compared to the original
    (local.set $i (i32.const 0))
    (local.set $changed (i32.const 0))
    (block $break_cmp_inter
      (loop $continue_cmp_inter
        (if (i32.ne (i32.load8_u (i32.add (local.get $i) (i32.const 3000))) (i32.load8_u (i32.add (local.get $i) (i32.const 2000))))
          (then
            (local.set $changed (i32.const 1))
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_cmp_inter (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    ;; EXTRA: check that it does not die (all 0) at step 1
    (local.set $i (i32.const 0))
    (local.set $matched (i32.const 0)) ;; temp use matched as a "has alive cell" boolean
    (block $break_check_alive
      (loop $continue_check_alive
        (if (i32.eq (i32.load8_u (i32.add (local.get $i) (i32.const 3000))) (i32.const 1))
          (then
            (local.set $matched (i32.const 1))
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_check_alive (i32.lt_s (local.get $i) (local.get $len)))
      )
    )
    (if (i32.eq (local.get $matched) (i32.const 0))
      (then (local.set $changed (i32.const 0))) ;; cancel out changed if it just died
    )

    ;; 2nd step
    (call $step)

    ;; Check if current grid matches the original grid
    (local.set $i (i32.const 0))
    (local.set $matched (i32.const 1))
    (block $break_cmp_final
      (loop $continue_cmp_final
        (if (i32.ne (i32.load8_u (local.get $i)) (i32.load8_u (i32.add (local.get $i) (i32.const 2000))))
          (then
            (local.set $matched (i32.const 0))
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_cmp_final (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    (if (i32.and (local.get $matched) (local.get $changed))
      (then
        unreachable
      )
    )
    (return)
  )

  (start $propriete3)
)