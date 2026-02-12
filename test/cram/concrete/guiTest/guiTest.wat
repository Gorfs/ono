(module
  ;; Import GUI primitives from the "ono" host module.
  (import "ono" "print_cell"   (func $print_cell   (param i32)))
  (import "ono" "newline"      (func $newline))
  (import "ono" "clear_screen" (func $clear_screen))
  (import "ono" "sleep"        (func $sleep         (param i32)))

  ;; Print a row of 8 cells with a given pattern.
  ;; $pattern is a bitmask: bit 0 = first cell, bit 7 = last cell.
  (func $print_row (param $pattern i32)
    (local $col i32)
    (local.set $col (i32.const 0))
    (block $done
      (loop $next
        (br_if $done (i32.ge_u (local.get $col) (i32.const 8)))
        ;; alive = (pattern >> col) & 1
        (call $print_cell
          (i32.and
            (i32.shr_u (local.get $pattern) (local.get $col))
            (i32.const 1)))
        (local.set $col (i32.add (local.get $col) (i32.const 1)))
        (br $next)))
    (call $newline))

  (func $main
    ;; Row 0: alternating on/off  -> 0b01010101 = 0x55 = 85
    (call $print_row (i32.const 85))
    ;; Row 1: alternating off/on  -> 0b10101010 = 0xAA = 170
    (call $print_row (i32.const 170))
    ;; Row 2: all alive           -> 0b11111111 = 0xFF = 255
    (call $print_row (i32.const 255))
    ;; Row 3: all dead            -> 0b00000000 = 0
    (call $print_row (i32.const 0))

    ;; Flush the frame to the window.
    (call $clear_screen)

    ;; Keep the window open for 30 seconds so we can see the result.
    (call $sleep (i32.const 30000)))
  (start $main)
)
