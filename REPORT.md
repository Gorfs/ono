# Rapport — Projet Ono

## Équipe

* **Archie Beales** — 22201677
* **Mathéo Piget** — 22200611
* **Méril Leforestier** — 22104824
* **Valentin Regnault** — 22510264
* **Thibault Rolland** — 22010976

## Vue d'ensemble

Ce projet consiste en l'implémentation d'un interpréteur WebAssembly (**concret et symbolique**) développé en OCaml. Cet interpréteur est utilisé pour exécuter un **Jeu de la Vie** écrit en Wasm, proposant deux modes de rendu : une interface textuelle (terminal) et une interface graphique (Raylib).

---

## Installation et Lancement

### Installation des dépendances

Pour installer les bibliothèques nécessaires, exécutez la commande suivante :

```bash
opam install . --with-test --with-dev-setup --with-doc --deps-only
```

*Note : En plus des dépendances de base, nous avons intégré **Alcotest** (tests unitaires), **Raylib** (graphismes), et **qcheck** (génération de tests).*

### Lancer le Jeu de la Vie (Interface Graphique)

```bash
dune exec -- ono concrete test/cram/concrete/gameoflife.t/game.wat --config doc/sample_config.txt --steps 70 --speed 10 --seed 42 --use-graphical-window true
```

**Détails des options :**

* `test/cram/concrete/gameoflife.t/game.wat` : Code WebAssembly du jeu.
* `--config doc/sample_config.txt` : Charge une configuration initiale. Dans ce fichier, chaque caractère représente une cellule : `.` pour une cellule morte et `@` pour une cellule vivante. Le fichier fourni contient un [planeur](https://fr.wikipedia.org/wiki/Planeur_(jeu_de_la_vie)).
* `--steps 70` : Nombre d'étapes à exécuter.
* `--speed 10` : Délai en millisecondes entre chaque étape (augmenter la valeur pour ralentir l'animation).
* `--seed 42` : Fixe la graine du générateur de nombres aléatoires (influence l'apparition aléatoire des cellules).
* `--use-graphical-window true` : Active l'interface graphique Raylib (si `false`, le rendu se fait dans le terminal).

---

## Génération de configurations (Exécution Symbolique)

Le mode symbolique permet de trouver des configurations initiales répondant à des critères spécifiques.

1. **Fichier source :** `test/cram/symbolic/config-generation.t/config-generation.wat`.
2. **Configuration :** Modifiez les valeurs `WIDTH` et `HEIGHT` (par défaut 4x4).
> **Attention :** L'augmentation de la taille de la grille accroît considérablement le temps de calcul.


3. **Choix de la propriété :** À la fin du fichier, modifiez l'instruction `start proprieteN` (où N est le numéro de la propriété) :
* **Propriété 1 :** La cellule (1, 1) est vivante après 1 tour.
* **Propriété 2 :** Un bloc 2x2 stable (cellules vivantes) apparaît après 1 tour.
* **Propriété 3 :** Création d'un **oscillateur de fréquence 2** (l'état change à l'étape 1 et revient à l'état initial à l'étape 2).
* **Propriété 4 (imparfaite) :** Après 4 étapes revient à l'état initial, décalée de (1, 1). Il s'agit d'un [planeur](https://fr.wikipedia.org/wiki/Planeur_(jeu_de_la_vie)). Cette propriété est incorrect, elle trouve parfois des configurations qui ne sont pas des planeurs.
> Nous avons fait le choix de ne pas implementer une longue liste de propriétés de difficultés equivalentes, mais plus d'implémenter des propriété de plus en plus complexes et exigeantes envers l'interpréteur symbolique (en particulier les deux dernières qu'il a fallu optimiser pour eviter l'explosion combinatoire).

4. **Exécution :**
```bash
dune exec -- ono symbolic config-generation/config-generation.wat

```

5. **Interprétation du résultat :** Le solveur génère un modèle sous la forme d'une liste de symboles (`symbol_0` à `symbol_n`). Chaque valeur (0 ou 1) correspond à l'état d'une cellule, lue ligne par ligne.

---

## Benchmark

Nous avons mesuré le temps d'exécution symbolique pour les trois premières propriétés de génération de configurations, sur une grille 4x4.

**Paramètres du benchmark :**

* **Source WAT :** `/Users/archie/fac/m1/s2/genie-logiciel-avance/ono/config-generation/config-generation.wat`
* **Exécutable :** `/Users/archie/fac/m1/s2/genie-logiciel-avance/ono/_build/default/src/tool/ono_main.exe`
* **Taille de grille :** 4x4
* **Runs de chauffe par propriété :** 3
* **Runs mesurés par propriété :** 10
* **Statut de sortie attendu :** 123, car l'exécution symbolique atteint volontairement une instruction `unreachable`.

| Propriété | Contrainte | Grille | Runs | Moyenne réelle | Médiane réelle | Min réel | Max réel | Statut |
|-----------|------------|--------|------|----------------|----------------|----------|----------|--------|
| 1 | cellule (1,1) vivante après 1 étape | 4x4 | 10/10 | 0.020s | 0.020s | 0.020s | 0.020s | ok |
| 2 | bloc vivant 2x2 après 1 étape | 4x4 | 10/10 | 0.051s | 0.050s | 0.040s | 0.090s | ok |
| 3 | oscillateur de période 2 | 4x4 | 10/10 | 1.947s | 1.945s | 1.900s | 2.010s | ok |

---

## Travail Réalisé

### Première partie — Interpréteur concret

* **Préliminaires** : Implémentation des modules Wasm `factorial`, `square_i64` (avec `print_i64` via OCaml) et `random_i32` (option `--seed` pour la reproductibilité). Tests Cram associés.
* **Interface textuelle** : Exposition des primitives `sleep`, `print_cell`, `newline`, et `clear_screen`. Implémentation complète du Jeu de la Vie en Wasm.
* **Extensions** : Ajout de `read_int` pour la saisie utilisateur, gestion des options `--steps`, `--display-last`, et système de chargement de grille via `--config`.
* **Interface graphique** : Intégration de Raylib permettant de basculer dynamiquement entre le mode texte et graphique avec le même code Wasm.

### Seconde partie — Interpréteur symbolique

* **Solveur de polynômes** : Résolution de degrés $\le 3$ avec énumération des racines entières.
* **Génération de structures** : Recherche de configurations complexes. Nous avons privilégié la recherche de propriétés intéressantes (comme les **oscillateurs**) plutôt qu'une accumulation de propriétés triviales.

### Tests

* **Tests Cram** : Couverture des commandes principales et des options CLI.
* **Tests unitaires (Alcotest)** : Validation des modules internes (`Concrete_ono_text`, `Symbolic_ono_module`, `Config_parser`, etc.).


## Difficultés rencontrées

* **CI / CD** : La mise en place de la pipeline de test a été laborieuse, et nous l'avons finalement supprimée. La lenteur d'exécution (plusieurs dizaines de minutes) et les échecs de Pull Requests parfois difficiles à interpréter nous ont ralentis.
* **Explosion combinatoire** : Lors de l'exécution symbolique, le nombre de chemins possibles augmente de façon exponentielle. Avec l'aide de l'enseignant, nous avons optimisé notre code pour réduire ces embranchements (notamment en remplaçant des if/else par des opérations binaires comme le `and`), permettant ainsi de traiter des grilles d'au moins 5x5 en un temps raisonnable.
* **Propriété 4** : malgré nos efforts, la propriété 4 qui cherchent des configuration de planeurs, s'arrête parfois sur des configurations qui n'en sont pas.
