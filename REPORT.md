# Rapport — Projet Ono

## Équipe

- Archie Beales — 22201677
- Mathéo Piget — 22200611
- Méril Leforestier — 22104824
- Valentin Regnault — 22510264
- Thibault Rolland — 22010976

## Vue d'ensemble

Ce projet implémente un interpréteur WebAssembly (concret et symbolique) en
OCaml, et utilise cet interpréteur pour faire tourner un Jeu de la Vie écrit
en Wasm avec deux modes de rendu : terminal et fenêtre graphique (Raylib).

## Ce qui a été réalisé

### Première partie — Interpréteur concret

- **Préliminaires** : modules Wasm `factorial`, `square_i64` (avec `print_i64`
  ajoutée côté OCaml), et `random_i32` avec une option `--seed` pour rendre
  les sorties reproductibles. Cram tests associés.
- **Interface textuelle** : primitives `sleep`, `print_cell`, `newline`,
  `clear_screen` exposées au Wasm. Jeu de la Vie complet en Wasm avec
  rendu terminal.
- **Extensions** : option `read_int` pour saisir des dimensions, options
  `--steps` et `--display-last`, format de fichier de configuration et
  option `--config FILE` pour charger une grille initiale.
- **Interface graphique** : version Raylib activable via le flag
  `--use-graphical-window`, partageant le même programme Wasm que le mode
  texte.

### Seconde partie — Interpréteur symbolique

- **Solveur de polynômes** de degré ≤ 3 avec lecture des coefficients sur
  l'entrée standard et énumération des racines entières.

### Tests

- Tests cram couvrant les principales commandes et options.
- Tests unitaires Alcotest pour les modules `Concrete_ono_text`,
  `Concrete_ono_module`, `Symbolic_ono_module`, `Config_parser`,
  `Cmd_concrete` et `Ono_cli`.

## Benchmarks

Les mesures suivantes suivent la méthodologie du chapitre 12.3 du support
*Advanced Software Engineering* : distinguer les micro-benchmarks des
macro-benchmarks, effectuer plusieurs répétitions, utiliser des exécutions
d'échauffement, et présenter les résultats avec une précision raisonnable.
Le support recommande `hyperfine` pour mesurer des outils en ligne de commande.
Comme `hyperfine` n'était pas installé sur la machine de test, nous avons
appliqué la même méthode avec `/usr/bin/time -p` : 3 exécutions
d'échauffement, puis 10 exécutions mesurées.

Les mesures ont été faites le 14 mai 2026 sur la machine de développement,
après construction de l'exécutable :

```sh
dune build src/tool/ono_main.exe
```

Commande équivalente avec `hyperfine` :

```sh
hyperfine --warmup 3 --runs 10 \
  "_build/default/src/tool/ono_main.exe concrete test/cram/concrete/factorial.t/factorial.wat"
```

Les temps ci-dessous sont des temps réels. La médiane est la valeur la plus
représentative, car les plus petits cas sont sensibles au bruit du scheduler
et aux coûts fixes de lancement.

| Cas mesuré | Type | Commande résumée | Moyenne | Médiane | Min | Max |
|------------|------|------------------|---------|---------|-----|-----|
| Factorielle | concret, micro | `factorial.wat` | 67 ms | 40 ms | 30 ms | 330 ms |
| Fibonacci | concret, micro | `fibonnaci.wat` | 36 ms | 30 ms | 30 ms | 80 ms |
| Carré `i64` | concret, micro | `square.wat` | 36 ms | 35 ms | 20 ms | 60 ms |
| Jeu de la Vie, 3 tours | concret, macro réduit | `game.wat --steps 3 --speed 0` | 51 ms | 50 ms | 40 ms | 60 ms |
| Jeu de la Vie, 100 tours | concret, macro | `game.wat --steps 100 --speed 0` | 619 ms | 610 ms | 570 ms | 680 ms |
| Solveur polynomial cubique | symbolique | `polynome.wat --no-stop-at-failure` | 570 ms | 530 ms | 460 ms | 870 ms |
| Génération de configuration | symbolique | `config-generation.wat` | 80 ms | 60 ms | 60 ms | 160 ms |

Deux mesures mémoire ponctuelles ont aussi été effectuées avec
`/usr/bin/time -lp` :

| Cas mesuré | Temps réel | Mémoire résidente maximale |
|------------|------------|----------------------------|
| Jeu de la Vie, 100 tours | 0,81 s | environ 60 MB |
| Solveur polynomial cubique | 0,72 s | environ 147 MB |

Ces résultats montrent que les petits programmes concrets mesurent surtout les
coûts fixes de parsing, compilation Wasm et lancement de l'interpréteur. Le Jeu
de la Vie sur 100 tours donne une mesure plus représentative de l'exécution
concrète. Le solveur polynomial est plus coûteux en mémoire, ce qui est attendu
pour l'exécution symbolique et l'utilisation du solveur SMT.
