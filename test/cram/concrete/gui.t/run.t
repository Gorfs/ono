
Test --use-graphical-window=false (mode texte, pas de logs Raylib) :
  $ dune exec -- ono concrete test_gui.wat --steps=1 --seed=1 --use-graphical-window=false

Test --use-graphical-window=false, steps=0 :
  $ dune exec -- ono concrete test_gui.wat --steps=0 --seed=1 --use-graphical-window=false

Test --use-graphical-window=false, plusieurs steps :
  $ dune exec -- ono concrete test_gui.wat --steps=5 --seed=42 --use-graphical-window=false

Test --use-graphical-window=true, steps=0 :
  $ dune exec -- ono concrete test_gui.wat --steps=0 --seed=1 --use-graphical-window=true | grep -v "^INFO:"

Test --use-graphical-window=true, steps=1 :
  $ dune exec -- ono concrete test_gui.wat --steps=1 --seed=1 --use-graphical-window=true | grep -v "^INFO:"

Test --use-graphical-window=true, steps=3 :
  $ dune exec -- ono concrete test_gui.wat --steps=3 --seed=1 --use-graphical-window=true | grep -v "^INFO:"

Test --use-graphical-window=true, steps=5 :
  $ dune exec -- ono concrete test_gui.wat --steps=5 --seed=1 --use-graphical-window=true | grep -v "^INFO:"

Test --use-graphical-window=true, seed différent :
  $ dune exec -- ono concrete test_gui.wat --steps=3 --seed=42 --use-graphical-window=true | grep -v "^INFO:"

Test valeur invalide pour --use-graphical-window :
  $ dune exec -- ono concrete test_gui.wat --steps=1 --use-graphical-window=oui
  Usage: ono concrete [--help] [OPTION]… FILE
  ono: option --use-graphical-window: invalid value oui, expected either true
       or false
  ono: [ERROR] command line parsing error
  [124]

Test sans --use-graphical-window (défaut) :
  $ dune exec -- ono concrete test_gui.wat --steps=1 --seed=1

Tests en boucle :

Test --use-graphical-window=false sur plusieurs seeds :
  $ for seed in 1 2 3 42 999; do
  > dune exec -- ono concrete test_gui.wat --steps=3 --seed=$seed --use-graphical-window=false
  > done

Test --use-graphical-window=false sur plusieurs steps :
  $ for steps in 0 1 2 5 10; do
  > dune exec -- ono concrete test_gui.wat --steps=$steps --seed=1 --use-graphical-window=false
  > done

