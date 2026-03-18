
Test écrits en dur :

Test --steps=1 : une seule étape, seed fixé
  $ dune exec -- ono concrete display.wat --steps=1 --seed=1

Test --steps=3 : trois étapes, seed fixé, pour voir si il y a des boucles
  $ dune exec -- ono concrete display.wat --steps=3 --seed=1

Test --steps=5 --display-last=1 : 5 étapes mais affiche seulement la dernière
  $ dune exec -- ono concrete display.wat --steps=5 --display-last=1 --seed=2

Test --steps=5 --display-last=3 : 5 étapes, affiche les 3 dernières, même principe
  $ dune exec -- ono concrete display.wat --steps=5 --display-last=3 --seed=2

Test --steps=10 --display-last=2 : seed différent, nouveau test pour bcp d'étapes
  $ dune exec -- ono concrete display.wat --steps=10 --display-last=2 --seed=3

Test --steps=1 --display-last=1 : cas de base
  $ dune exec -- ono concrete display.wat --steps=1 --display-last=1 --seed=4

Test --steps=3 --display-last=3 : display-last = steps, tout afficher
  $ dune exec -- ono concrete display.wat --steps=3 --display-last=3 --seed=5

Test --display-last supérieur à steps : display-last=10 mais steps=3
  $ dune exec -- ono concrete display.wat --steps=3 --display-last=10 --seed=6

Test --steps=0 : aucune étape, rien ne doit s'afficher
  $ dune exec -- ono concrete display.wat --steps=0 --seed=1

Test sans --display-last : comportement par défaut
  $ dune exec -- ono concrete display.wat --steps=5 --seed=1

Test --display-last=0 : aucun affichage
  $ dune exec -- ono concrete display.wat --steps=5 --display-last=0 --seed=1


Tests avec des boucles :


Test seeds différents :
  $ for seed in 7 8 3 9 54 96 999 123456; do
  > dune exec -- ono concrete display.wat --steps=3 --seed=$seed
  > done

Test steps différents :
  $ for steps in 1 2 3 5 10 15 20; do
  > dune exec -- ono concrete display.wat --steps=$steps --seed=123456
  > done

Test display-last différents :
  $ for n in 1 2 3 4 5 6; do
  > dune exec -- ono concrete display.wat --steps=5 --display-last=$n --seed=123456
  > done

Test display-last supérieur à steps sur plusieurs valeurs :
  $ for n in 5 10 15 20 25; do
  > dune exec -- ono concrete display.wat --steps=3 --display-last=$n --seed=123455
  > done

Test steps=0 avec plusieurs seeds :
  $ for seed in 1 2 3 42 999; do
  > dune exec -- ono concrete display.wat --steps=0 --seed=$seed
  > done

Test display-last=0 avec plusieurs steps :
  $ for steps in 1 3 5 10; do
  > dune exec -- ono concrete display.wat --steps=$steps --display-last=0 --seed=42
  > done

Test display-last=steps (tout afficher) sur plusieurs valeurs :
  $ for n in 1 2 3 5 10; do
  > dune exec -- ono concrete display.wat --steps=$n --display-last=$n --seed=7
  > done
