(module
  (import "ono" "get_steps" (func $get_steps (result i32)))
  (import "ono" "random_i32" (func $random (result i32)))
  (import "ono" "cell_print" (func $cell_print (param i32)))
  (import "ono" "newline" (func $newline))
  (import "ono" "clear_screen" (func $clear_screen))

  (global $WIDTH i32 (i32.const 90))
  (global $HEIGHT i32 (i32.const 50))

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
    (local $nb_rand i32)
    (local $cell i32)

    (local.set $i (i32.const 0))

    (block $break_i
      (loop $continue_i

      (local.set $j (i32.const 0))
        (block $break_j
          (loop $continue_j

          (local.set $index (call $coord_to_index (local.get $i) (local.get $j)))

          (local.set $nb_rand (call $random))
          (local.set $nb_rand (i32.rem_u (local.get $nb_rand) (i32.const 100))) ;; 10% de chance de créer une cellule vivante
          (if (i32.gt_s (local.get $nb_rand) (i32.const 90))
            (then (local.set $cell (i32.const 1 )))
            (else (local.set $cell (i32.const 0 )))
          )
          (i32.store8 (local.get $index) (local.get $cell))
          
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
            (local.set $nb_rand (i32.rem_u (call $random) (i32.const 10000)))
            (local.set $cell_alive 
              (i32.or 
                (local.get $cell_alive)
                (i32.eqz (local.get $nb_rand))
              )
            )

            (i32.store8 (i32.add (local.get $index) (i32.const 4500)) (local.get $cell_alive))
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
        (br_if $continue_copy (i32.lt_s (local.get $i) (i32.const 4500)))
      )
    )
  )


  (func $print_grid
    (local $i i32)
    (local $j i32)
    (local $index i32)
    (local $cell_value i32)

    (call $clear_screen)
    (local.set $i (i32.const 0))
    (block $break_i
      (loop $continue_i
        (local.set $j (i32.const 0))
        (block $break_j
          (loop $continue_j

            (local.set $index (call $coord_to_index (local.get $i) (local.get $j)))
            (local.set $cell_value (i32.load8_u (local.get $index)))
            (call $cell_print (local.get $cell_value))  


            (local.set $j (i32.add (local.get $j) (i32.const 1)))
            (br_if $continue_j (i32.lt_s (local.get $j) (global.get $WIDTH)))    
          )
          (call $newline)
        )   
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_i (i32.lt_s (local.get $i) (global.get $HEIGHT)))
      )
    )
  )

  (func $main (export "main")
    (local $steps i32)
    (local $i i32)
    
    (local.set $steps (call $get_steps))  ;; récupère le nb de steps
    (local.set $i (i32.const 0))
    
    (call $init_grid)
    
    (block $break
      (loop $game_loop
        (br_if $break (i32.ge_s (local.get $i) (local.get $steps)))  ;; sort si i >= steps
        (call $print_grid)
        (call $step)
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $game_loop)
      )
    )
  )
  (start $main)
)