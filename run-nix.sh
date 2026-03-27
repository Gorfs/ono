#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

nix-shell --run '
  set -e
  ODOC_WARN_ERROR=true
  dune build @fmt
  dune build @doc
  dune build @install
  dune build @all
  dune runtest
'

nix-shell -p git --run '
  git diff --exit-code ono.opam
'
