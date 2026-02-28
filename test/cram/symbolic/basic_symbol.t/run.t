Check that branching works:
  $ ono symbolic branching_false.wat -vv
  INFO: Initializing raylib 5.5
  INFO: Platform backend: DESKTOP (GLFW)
  INFO: Supported raylib modules:
  INFO:     > rcore:..... loaded (mandatory)
  INFO:     > rlgl:...... loaded (mandatory)
  INFO:     > rshapes:... loaded (optional)
  INFO:     > rtextures:. loaded (optional)
  INFO:     > rtext:..... loaded (optional)
  INFO:     > rmodels:... loaded (optional)
  INFO:     > raudio:.... loaded (optional)
  INFO: DISPLAY: Device initialized successfully
  INFO:     > Display size: 1920 x 1080
  INFO:     > Screen size:  2120 x 1080
  INFO:     > Render size:  2120 x 1080
  INFO:     > Viewport offsets: 0, 0
  INFO: GLAD: OpenGL extensions loaded successfully
  INFO: GL: Supported extensions count: 43
  INFO: GL: OpenGL device information:
  INFO:     > Vendor:   Apple
  INFO:     > Renderer: Apple M2
  INFO:     > Version:  4.1 Metal - 90.5
  INFO:     > GLSL:     4.10
  INFO: GL: VAO extension detected, VAO functions loaded successfully
  INFO: GL: NPOT textures extension detected, full NPOT textures supported
  INFO: GL: DXT compressed textures supported
  INFO: PLATFORM: DESKTOP (GLFW - Cocoa): Initialized successfully
  INFO: TEXTURE: [ID 1] Texture loaded successfully (1x1 | R8G8B8A8 | 1 mipmaps)
  INFO: TEXTURE: [ID 1] Default texture loaded successfully
  INFO: SHADER: [ID 1] Vertex shader compiled successfully
  INFO: SHADER: [ID 2] Fragment shader compiled successfully
  INFO: SHADER: [ID 3] Program shader loaded successfully
  INFO: SHADER: [ID 3] Default shader loaded successfully
  INFO: RLGL: Render batch vertex buffers loaded successfully in RAM (CPU)
  INFO: RLGL: Render batch vertex buffers loaded successfully in VRAM (GPU)
  INFO: RLGL: Default OpenGL state initialized successfully
  INFO: TEXTURE: [ID 2] Texture loaded successfully (128x128 | GRAY_ALPHA | 1 mipmaps)
  INFO: FONT: Default font loaded successfully (224 glyphs)
  INFO: SYSTEM: Working Directory: $TESTCASE_ROOT
  ono: [INFO] Parsing file branching_false.wat...
  ono: [DEBUG] Parsed module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (func $main (local $n i32)
                   call $i32_symbol
                   local.tee $n
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       return
                     )
                     (else
                       unreachable
                     )
                   )
                 )
                 (start $main)
               )
  ono: [INFO] Compiling to Wasm...
  ono: [DEBUG] Compiled module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (type (func (result i32)))
                 (type (func (param i32)))
                 (type (func))
                 (func $main (local $n i32)
                   call 0
                   local.tee 0
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       return
                     )
                     (else
                       unreachable
                     )
                   )
                 )
                 (start 2)
               )
  ono: [INFO] Validating...
  ono: [INFO] Linking...
  ono: [INFO] Interpreting...
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 1073741824
  }
  breadcrumbs 0
  ono: [ERROR] owi error: Reached problem!
  [123]

  $ ono symbolic branching_true.wat -vv
  INFO: Initializing raylib 5.5
  INFO: Platform backend: DESKTOP (GLFW)
  INFO: Supported raylib modules:
  INFO:     > rcore:..... loaded (mandatory)
  INFO:     > rlgl:...... loaded (mandatory)
  INFO:     > rshapes:... loaded (optional)
  INFO:     > rtextures:. loaded (optional)
  INFO:     > rtext:..... loaded (optional)
  INFO:     > rmodels:... loaded (optional)
  INFO:     > raudio:.... loaded (optional)
  INFO: DISPLAY: Device initialized successfully
  INFO:     > Display size: 1920 x 1080
  INFO:     > Screen size:  2120 x 1080
  INFO:     > Render size:  2120 x 1080
  INFO:     > Viewport offsets: 0, 0
  INFO: GLAD: OpenGL extensions loaded successfully
  INFO: GL: Supported extensions count: 43
  INFO: GL: OpenGL device information:
  INFO:     > Vendor:   Apple
  INFO:     > Renderer: Apple M2
  INFO:     > Version:  4.1 Metal - 90.5
  INFO:     > GLSL:     4.10
  INFO: GL: VAO extension detected, VAO functions loaded successfully
  INFO: GL: NPOT textures extension detected, full NPOT textures supported
  INFO: GL: DXT compressed textures supported
  INFO: PLATFORM: DESKTOP (GLFW - Cocoa): Initialized successfully
  INFO: TEXTURE: [ID 1] Texture loaded successfully (1x1 | R8G8B8A8 | 1 mipmaps)
  INFO: TEXTURE: [ID 1] Default texture loaded successfully
  INFO: SHADER: [ID 1] Vertex shader compiled successfully
  INFO: SHADER: [ID 2] Fragment shader compiled successfully
  INFO: SHADER: [ID 3] Program shader loaded successfully
  INFO: SHADER: [ID 3] Default shader loaded successfully
  INFO: RLGL: Render batch vertex buffers loaded successfully in RAM (CPU)
  INFO: RLGL: Render batch vertex buffers loaded successfully in VRAM (GPU)
  INFO: RLGL: Default OpenGL state initialized successfully
  INFO: TEXTURE: [ID 2] Texture loaded successfully (128x128 | GRAY_ALPHA | 1 mipmaps)
  INFO: FONT: Default font loaded successfully (224 glyphs)
  INFO: SYSTEM: Working Directory: $TESTCASE_ROOT
  ono: [INFO] Parsing file branching_true.wat...
  ono: [DEBUG] Parsed module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (func $main (local $n i32)
                   call $i32_symbol
                   local.tee $n
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       unreachable
                     )
                     (else
                       return
                     )
                   )
                 )
                 (start $main)
               )
  ono: [INFO] Compiling to Wasm...
  ono: [DEBUG] Compiled module is:  
               (module
                 (import "ono" "i32_symbol" (func $i32_symbol  (result i32)))
                 (import "ono" "print_i32" (func $print_i32  (param i32)))
                 (type (func (result i32)))
                 (type (func (param i32)))
                 (type (func))
                 (func $main (local $n i32)
                   call 0
                   local.tee 0
                   i32.const 42
                   i32.lt_s
                   (if
                     (then
                       unreachable
                     )
                     (else
                       return
                     )
                   )
                 )
                 (start 2)
               )
  ono: [INFO] Validating...
  ono: [INFO] Linking...
  ono: [INFO] Interpreting...
  ono: [ERROR] Trap: unreachable
  model {
    symbol symbol_0 i32 0
  }
  breadcrumbs 1
  ono: [ERROR] owi error: Reached problem!
  [123]
