On compile et on lance le solveur avec les coefficients 1, -7, 14, -8.
Le polynôme est x^3 - 7x^2 + 14x - 8 = 0. Les racines sont 1, 2, et 4.

  $ cat > input.txt <<EOF
  > 1
  > -7
  > 14
  > -8
  > EOF

  $ ono symbolic polynome.wat < input.txt
  Please enter an integer: Please enter an integer: Please enter an integer: Please enter an integer: ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 4
  }
  breadcrumbs 1

  ono: [ERROR] owi error: Reached problem!
  [123]
