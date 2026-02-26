(module
  ;; 1. Imports
  (func $read_int (import "ono" "read_int") (result i32))
  (func $symbol_int (import "ono" "i32_symbol") (result i32))

  (func $main
    ;; 2. Variables locales
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $d i32)
    (local $x i32)

    ;; 3. Lecture des coefficients entrés par l'utilisateur
    call $read_int
    local.set $a
    call $read_int
    local.set $b
    call $read_int
    local.set $c
    call $read_int
    local.set $d

    ;; 4. Création de la variable symbolique X
    call $symbol_int
    local.set $x

    ;; 5. Calcul du polynôme : ax^3 + bx^2 + cx + d
    ;; Utilisation de la méthode de Horner : ((a*x + b)*x + c)*x + d

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

    ;; 6. Vérification : est-ce égal à 0 ?
    i32.const 0
    i32.eq

    ;; 7. Piège : Si c'est égal à 0, on provoque une erreur "unreachable"
    (if
      (then
        unreachable
      )
    )
  )
  (start $main)
)
