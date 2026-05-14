#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WAT_FILE="${WAT_FILE:-$ROOT_DIR/config-generation/config-generation.wat}"
EXE="${EXE:-$ROOT_DIR/_build/default/src/tool/ono_main.exe}"
RUNS="${RUNS:-10}"
WARMUP="${WARMUP:-3}"
EXPECTED_STATUS=123

if [ ! -x "$EXE" ]; then
  echo "Building Ono executable: dune build src/tool/ono_main.exe" >&2
  (cd "$ROOT_DIR" && dune build src/tool/ono_main.exe) || exit 1
fi

if [ ! -f "$WAT_FILE" ]; then
  echo "Missing WAT file: $WAT_FILE" >&2
  exit 1
fi

WIDTH="$(sed -nE 's/.*\(global \$WIDTH i32 \(i32.const ([0-9]+)\)\).*/\1/p' "$WAT_FILE" | head -1)"
HEIGHT="$(sed -nE 's/.*\(global \$HEIGHT i32 \(i32.const ([0-9]+)\)\).*/\1/p' "$WAT_FILE" | head -1)"
SIZE="${WIDTH:-?}x${HEIGHT:-?}"

make_wat_for_property() {
  local property="$1"
  local tmp="$2"
  sed -E 's/\(start \$propriete[0-9]+\)/(start $propriete'"${property}"')/' \
    "$WAT_FILE" > "$tmp"
}

run_once() {
  local wat="$1"
  local out status real user sys
  out="$({ /usr/bin/time -p "$EXE" symbolic "$wat" --no-stop-at-failure >/dev/null; printf 'status=%s\n' "$?"; } 2>&1)"
  status="$(printf '%s\n' "$out" | sed -nE 's/^status=([0-9]+)$/\1/p' | tail -1)"
  real="$(printf '%s\n' "$out" | awk '/^real / {print $2}' | tail -1)"
  user="$(printf '%s\n' "$out" | awk '/^user / {print $2}' | tail -1)"
  sys="$(printf '%s\n' "$out" | awk '/^sys / {print $2}' | tail -1)"
  printf '%s %s %s %s\n' "${real:-nan}" "${user:-nan}" "${sys:-nan}" "${status:-unknown}"
}

summarize() {
  local property="$1"
  local description="$2"
  local file="$3"
  awk -v property="$property" -v description="$description" -v size="$SIZE" \
      -v runs="$RUNS" -v expected="$EXPECTED_STATUS" '
    $1 != "nan" {
      n += 1
      r[n] = $1
      u[n] = $2
      s[n] = $3
      status[n] = $4
      real_sum += $1
      user_sum += $2
      sys_sum += $3
      if ($4 != expected) bad_status = 1
    }
    END {
      for (i = 1; i <= n; i++) {
        for (j = i + 1; j <= n; j++) {
          if (r[i] > r[j]) {
            tr = r[i]; r[i] = r[j]; r[j] = tr
          }
        }
      }
      if (n == 0) {
        printf "| %s | %s | %s | 0/%s | ERROR | ERROR | ERROR | ERROR | ERROR |\n",
          property, description, size, runs
        exit
      }
      if (n % 2 == 1) median = r[(n + 1) / 2]
      else median = (r[n / 2] + r[(n / 2) + 1]) / 2
      status_text = bad_status ? "unexpected" : "ok"
      printf "| %s | %s | %s | %d/%s | %.3fs | %.3fs | %.3fs | %.3fs | %s |\n",
        property, description, size, n, runs, real_sum / n, median, r[1], r[n], status_text
    }
  ' "$file"
}

echo "# Symbolic configuration generation benchmark"
echo
echo "Source WAT: $WAT_FILE"
echo "Executable: $EXE"
echo "Grid size: $SIZE"
echo "Warmup runs per property: $WARMUP"
echo "Measured runs per property: $RUNS"
echo "Expected exit status: $EXPECTED_STATUS (symbolic execution reaches an intentional unreachable)"
echo
echo "| Propriete | Constraint | Grid | Runs | Real mean | Real median | Real min | Real max | Status |"
echo "|-----------|------------|------|------|-----------|-------------|----------|----------|--------|"

for property in 1 2 3; do
  case "$property" in
    1) description="cell (1,1) alive after 1 step" ;;
    2) description="2x2 live block after 1 step" ;;
    3) description="period-2 oscillator" ;;
  esac

  tmp_wat="$(mktemp "/private/tmp/ono-config-prop${property}-wat.XXXXXX")"
  tmp_results="$(mktemp "/private/tmp/ono-config-prop${property}-results.XXXXXX")"
  make_wat_for_property "$property" "$tmp_wat"

  for _ in $(seq 1 "$WARMUP"); do
    run_once "$tmp_wat" >/dev/null
  done

  for _ in $(seq 1 "$RUNS"); do
    run_once "$tmp_wat" >> "$tmp_results"
  done

  summarize "$property" "$description" "$tmp_results"
  rm -f "$tmp_wat" "$tmp_results"
done
