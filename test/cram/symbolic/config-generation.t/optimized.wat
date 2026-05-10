(module
  (func $i32_symbol (import "ono" "i32_symbol") (result i32))

  (global $WIDTH i32 (i32.const 4))
  (global $HEIGHT i32 (i32.const 4))

  (memory (export "memory") 1)


  (func $coord_to_index (param $i i32) (param $j i32) (result i32)
    (local $temp i32)
    (local.set $temp (i32.mul (local.get $i) (global.get $WIDTH)))
    (local.set $temp (i32.add (local.get $temp) (local.get $j)))
    (local.get $temp)
  )

  (func $is_alive (param $i i32) (param $j i32) (result i32)
    (local $in_bounds i32)
    ;; Évalue si (i, j) se trouve dans la grille sans création de branchements.
    ;; $in_bounds vaudra 1 si (0 <= i < HEIGHT) et (0 <= j < WIDTH), sinon 0.
    (local.set $in_bounds
      (i32.and
        (i32.and
          (i32.ge_s (local.get $i) (i32.const 0))
          (i32.lt_s (local.get $i) (global.get $HEIGHT))
        )
        (i32.and
          (i32.ge_s (local.get $j) (i32.const 0))
          (i32.lt_s (local.get $j) (global.get $WIDTH))
        )
      )
    )
    ;; On évite les branchements (if) lors du chargement :
    ;; Si hors limites, $in_bounds = 0, on lit à l'index 0, et on multiplie par 0 -> renvoie 0.
    ;; Si dans les limites, $in_bounds = 1, on lit au vrai index, et on multiplie par 1 -> renvoie la valeur.
    (i32.mul
      (local.get $in_bounds) ;; pile: [in_bounds]
      (i32.load8_u
        (i32.mul
          (local.get $in_bounds)                                ;; pile: [in_bounds, in_bounds]
          (call $coord_to_index (local.get $i) (local.get $j))  ;; pile: [in_bounds, in_bounds, index]
        ) ;; pile: [in_bounds, in_bounds * index]
      )   ;; pile: [in_bounds, memory_value]
    )     ;; pile: [in_bounds * memory_value] (valeur retournée, 0 ou 1)
  )


  ;; Compte le nombre de cellules vivantes autour d'une cellule sans boucle ni condition
  (func $count_neighbours (param $i i32) (param $j i32) (result i32)
    ;; Effectue la somme des 8 appels immédiats à `is_alive` pour éviter 8 branchements if/else
    ;; Note: `is_alive` gère le out-of-bounds seul en renvoyant 0.
    (i32.add
      (i32.add
        (i32.add
          (call $is_alive (i32.sub (local.get $i) (i32.const 1)) (i32.sub (local.get $j) (i32.const 1))) ;; Top-Left
          (call $is_alive (i32.sub (local.get $i) (i32.const 1)) (local.get $j))                         ;; Top
        ) ;; pile: [sum(Top-Left, Top)]
        (i32.add ;; pile: [sum(Top-Left, Top), ...]
          (call $is_alive (i32.sub (local.get $i) (i32.const 1)) (i32.add (local.get $j) (i32.const 1))) ;; Top-Right
          (call $is_alive (local.get $i) (i32.sub (local.get $j) (i32.const 1)))                         ;; Left
        ) ;; pile: [sum(Top-Left, Top), sum(Top-Right, Left)]
      )   ;; pile: [sum(TL, T, TR, L)]
      (i32.add ;; pile: [sum(TL, T, TR, L), ...]
        (i32.add
          (call $is_alive (local.get $i) (i32.add (local.get $j) (i32.const 1)))                         ;; Right
          (call $is_alive (i32.add (local.get $i) (i32.const 1)) (i32.sub (local.get $j) (i32.const 1))) ;; Bottom-Left
        )
        (i32.add
          (call $is_alive (i32.add (local.get $i) (i32.const 1)) (local.get $j))                         ;; Bottom
          (call $is_alive (i32.add (local.get $i) (i32.const 1)) (i32.add (local.get $j) (i32.const 1))) ;; Bottom-Right
        )
      )
    ) ;; pile finale: [somme_totale_des_8_voisins_vivants]
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
          ;; Création d'une valeur symbolique de type i32 (ex: symbole s1, s2...)
          call $i32_symbol ;; pile: [symbole_i32]
          ;; On force ce symbole dans l'intervalle {0, 1} en masquant tous les autres bits
          i32.const 1 ;; pile: [symbole_i32, 1]
          i32.and     ;; pile: [(symbole_i32 & 0x01)]  (si le symbole valait 0 (pair), il vaut toujours 0, sinon, il vaut maintenant 1)
          local.set $cell_symbolic ;; on sauvegarde le symbole booléen
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
            ;; Détermine si la cellule survit ou non uniquement avec des opérateurs bit-à-bit pour éviter
            ;; tout branchement `if / else` de l'exécution symbolique.
            ;; Logique formelle : cell_alive = (neighbours == 3) | (is_alive & neighbours == 2)
            (local.set $cell_alive
              (i32.or
                (i32.eq (local.get $neighbours) (i32.const 3)) ;; pile: [(neighbours == 3)]
                (i32.and ;; pile: [(neighbours == 3), (is_alive && neighbours == 2)]
                  (call $is_alive (local.get $i) (local.get $j)) ;; pile: [(neighbours == 3), is_alive]
                  (i32.eq (local.get $neighbours) (i32.const 2)) ;; pile: [(neighbours == 3), is_alive, (neighbours == 2)]
                )
              ) ;; pile: [nouvelle_etat_boolean_0_ou_1]
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

  ;; Propriété 1 : Après 1 tour, la cellule (1, 1) est vivante
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

  ;; Propriété 2 : Après un tour, il y a un groupe de 2x2 cellule vivante quelque part sur la grille
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

            (local.set $found
              (i32.or
                (local.get $found)
                (i32.and
                  (i32.and (local.get $alive1) (local.get $alive2))
                  (i32.and (local.get $alive3) (local.get $alive4))
                )
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

  ;; Propriété 3 : Après 1 étape, l'état de la grille a changé, et après 2 étapes, il est revenu à l'état initial.
  ;; i.e il s'agit d'un oscillateur de fréquence 2.
  (func $propriete3 (export "propriete3")
    (local $i i32)
    (local $len i32)
    (local $matched i32)
    (local $changed i32)

    (call $init_grid)

    ;; Enregistre la grille originale à l'offset 2000
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

    ;; 1ère étape
    (call $step)

    ;; Enregistre la grille intermédiaire à l'offset 3000
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

    ;; On vérifie que la grille a changé
    (local.set $i (i32.const 0))
    (local.set $changed (i32.const 0))
    (block $break_cmp_inter
      (loop $continue_cmp_inter
        (if (i32.ne (i32.load8_u (i32.add (local.get $i) (i32.const 3000))) (i32.load8_u (i32.add (local.get $i) (i32.const 2000))))
          (then
            (local.set $changed (i32.const 1))
            (br $break_cmp_inter)
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_cmp_inter (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    (if (i32.eq (local.get $changed) (i32.const 0))
      (then (return))
    )

    ;; 2 eme étape
    (call $step)

    ;; On vérifie que la grille actuelle correspond à la grille originale
    (local.set $i (i32.const 0))
    (local.set $matched (i32.const 1))
    (block $break_cmp_final
      (loop $continue_cmp_final
        (if (i32.ne (i32._u_u (local.get $i)) (i32.load8_u (i32.add (local.get $i) (i32.const 2000))))
          (then
            (local.set $matched (i32.const 0))
            (br $break_cmp_final)
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_cmp_final (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    (if (local.get $matched)
      (then
        unreachable
      )
    )
    (return)
  )

  ;; Propriété 4 : Une configuration de départ qui après 4 étapes revient à l'état initial, décalée de (1, 1)
  ;; i.e il s'agit d'un planeur.
  (func $propriete4 (export "propriete4")
    (local $i i32)
    (local $len i32)
    (local $matched i32)
    (local $changed i32)

    (call $init_grid)

    ;; verifier que ce n'est pas la configuration vide
    (local.set $i (i32.const 0))
    (local.set $changed (i32.const 0))
    (block $break_non_empty
      (loop $continue_non_empty
        (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 0))
          (then
            (local.set $changed (i32.const 1))
            (br $break_non_empty)
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_non_empty (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    ;; Enregistre la grille originale à l'offset 2000
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

    ;; 4 étapes
    (call $step)
    (call $step)
    (call $step)
    (call $step)
    (call $step)

    ;; On vérifie que la grille actuelle correspond à la grille originale décalée de (1, 1)
    (local.set $i (i32.const 0))
    (local.set $matched (i32.const 1))
    (block $break_cmp_final
      (loop $continue_cmp_final
        ;; On vérifie si l'index courant correspond au bord supérieur (i < WIDTH)
        ;; ou au bord gauche (i % WIDTH == 0) de la grille.
        (if (i32.or
              (i32.lt_u (local.get $i) (global.get $WIDTH))                         ;; pile: [i < WIDTH]
              (i32.eq (i32.rem_u (local.get $i) (global.get $WIDTH)) (i32.const 0)) ;; pile: [i < WIDTH, (i % WIDTH) == 0]
            ) ;; pile: [(i < WIDTH) | ((i % WIDTH) == 0)]
          (then
            ;; bord supérieur ou gauche: la case d'origine "décalée" (-1, -1) serait hors grille (donc morte par défaut)
            ;; On doit s'assurer que la case courante est bien morte (0).
            (if (i32.ne (i32.load8_u (local.get $i)) (i32.const 0))                 ;; pile: [valeur_cellule_actuelle != 0]
              (then
                (local.set $matched (i32.const 0))
                (br $break_cmp_final) ;; Sortie précoce (early exit) pour optimiser l'exécution symbolique
              )
            )
          )
          (else
            ;; sinon, on compare avec la case i - WIDTH - 1 dans la grille d'origine (offset 2000)
            ;; Cela correspond à reculer d'une ligne (-WIDTH) et d'une colonne (-1)
            (if (i32.ne
                  (i32.load8_u (local.get $i)) ;; pile: [valeur_cellule_actuelle]
                  (i32.load8_u
                    (i32.add
                      (i32.sub
                        (i32.sub (local.get $i) (global.get $WIDTH)) ;; calcul i - WIDTH
                        (i32.const 1)                                ;; calcul (i - WIDTH) - 1
                      )
                      (i32.const 2000)                               ;; calcul (i - WIDTH - 1) + 2000 (offset de la sauvegarde)
                    ) ;; pile: [valeur_cellule_actuelle, index_origine_decale]
                  )   ;; pile: [valeur_cellule_actuelle, valeur_cellule_origine_decalee]
                )     ;; pile: [valeur_actuelle != valeur_origine_decalee]
              (then
                (local.set $matched (i32.const 0))
                (br $break_cmp_final) ;; Sortie précoce (early exit)
              )
            )
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br_if $continue_cmp_final (i32.lt_s (local.get $i) (local.get $len)))
      )
    )

    (if (local.get $matched)
      (then
        unreachable
      )
    )
    (return)
  )

  (start $propriete4)
)