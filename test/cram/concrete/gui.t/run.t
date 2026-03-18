
Test --use-graphical-window=false (mode texte, pas de logs Raylib) :
  $ dune exec -- ono concrete gui.wat --steps=1 --seed=1 --use-graphical-window=false
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>

Test --use-graphical-window=false, steps=0 :
  $ dune exec -- ono concrete gui.wat --steps=0 --seed=1 --use-graphical-window=false
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  OK!

Test --use-graphical-window=false, plusieurs steps :
  $ dune exec -- ono concrete gui.wat --steps=5 --seed=42 --use-graphical-window=false
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>

Test --use-graphical-window=true, steps=0 (fenêtre s'ouvre et se ferme) :
  $ dune exec -- ono concrete gui.wat --steps=0 --seed=1 --use-graphical-window=true
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
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
  INFO: GL: Supported extensions count: 229
  INFO: GL: OpenGL device information:
  INFO:     > Vendor:   Mesa
  INFO:     > Renderer: llvmpipe (LLVM 20.1.2, 256 bits)
  INFO:     > Version:  4.5 (Core Profile) Mesa 25.2.8-0ubuntu0.24.04.1
  INFO:     > GLSL:     4.50
  INFO: GL: VAO extension detected, VAO functions loaded successfully
  INFO: GL: NPOT textures extension detected, full NPOT textures supported
  INFO: GL: DXT compressed textures supported
  INFO: GL: ETC2/EAC compressed textures supported
  INFO: PLATFORM: DESKTOP (GLFW - X11): Initialized successfully
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
  OK!

Test --use-graphical-window=true, steps=1 :
  $ dune exec -- ono concrete gui.wat --steps=1 --seed=1 --use-graphical-window=true
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
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
  INFO: GL: Supported extensions count: 229
  INFO: GL: OpenGL device information:
  INFO:     > Vendor:   Mesa
  INFO:     > Renderer: llvmpipe (LLVM 20.1.2, 256 bits)
  INFO:     > Version:  4.5 (Core Profile) Mesa 25.2.8-0ubuntu0.24.04.1
  INFO:     > GLSL:     4.50
  INFO: GL: VAO extension detected, VAO functions loaded successfully
  INFO: GL: NPOT textures extension detected, full NPOT textures supported
  INFO: GL: DXT compressed textures supported
  INFO: GL: ETC2/EAC compressed textures supported
  INFO: PLATFORM: DESKTOP (GLFW - X11): Initialized successfully
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

Test --use-graphical-window=true, steps=3 :
  $ dune exec -- ono concrete gui.wat --steps=3 --seed=1 --use-graphical-window=true
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
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
  INFO: GL: Supported extensions count: 229
  INFO: GL: OpenGL device information:
  INFO:     > Vendor:   Mesa
  INFO:     > Renderer: llvmpipe (LLVM 20.1.2, 256 bits)
  INFO:     > Version:  4.5 (Core Profile) Mesa 25.2.8-0ubuntu0.24.04.1
  INFO:     > GLSL:     4.50
  INFO: GL: VAO extension detected, VAO functions loaded successfully
  INFO: GL: NPOT textures extension detected, full NPOT textures supported
  INFO: GL: DXT compressed textures supported
  INFO: GL: ETC2/EAC compressed textures supported
  INFO: PLATFORM: DESKTOP (GLFW - X11): Initialized successfully
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

Test --use-graphical-window=true, steps=5 :
  $ dune exec -- ono concrete gui.wat --steps=5 --seed=1 --use-graphical-window=true
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
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
  INFO: GL: Supported extensions count: 229
  INFO: GL: OpenGL device information:
  INFO:     > Vendor:   Mesa
  INFO:     > Renderer: llvmpipe (LLVM 20.1.2, 256 bits)
  INFO:     > Version:  4.5 (Core Profile) Mesa 25.2.8-0ubuntu0.24.04.1
  INFO:     > GLSL:     4.50
  INFO: GL: VAO extension detected, VAO functions loaded successfully
  INFO: GL: NPOT textures extension detected, full NPOT textures supported
  INFO: GL: DXT compressed textures supported
  INFO: GL: ETC2/EAC compressed textures supported
  INFO: PLATFORM: DESKTOP (GLFW - X11): Initialized successfully
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

Test --use-graphical-window=true, seed différent :
  $ dune exec -- ono concrete gui.wat --steps=3 --seed=42 --use-graphical-window=true
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
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
  INFO: GL: Supported extensions count: 229
  INFO: GL: OpenGL device information:
  INFO:     > Vendor:   Mesa
  INFO:     > Renderer: llvmpipe (LLVM 20.1.2, 256 bits)
  INFO:     > Version:  4.5 (Core Profile) Mesa 25.2.8-0ubuntu0.24.04.1
  INFO:     > GLSL:     4.50
  INFO: GL: VAO extension detected, VAO functions loaded successfully
  INFO: GL: NPOT textures extension detected, full NPOT textures supported
  INFO: GL: DXT compressed textures supported
  INFO: GL: ETC2/EAC compressed textures supported
  INFO: PLATFORM: DESKTOP (GLFW - X11): Initialized successfully
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

Test valeur invalide pour --use-graphical-window :
  $ dune exec -- ono concrete gui.wat --steps=1 --use-graphical-window=oui
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  Usage: ono concrete [--help] [OPTION]… FILE
  ono: option --use-graphical-window: invalid value oui, expected either true
       or false
  ono: [ERROR] command line parsing error
  [124]

Test sans --use-graphical-window (défaut) :
  $ dune exec -- ono concrete gui.wat --steps=1 --seed=1
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>


Tests en boucle :

Test --use-graphical-window=false sur plusieurs seeds :
  $ for seed in 1 2 3 42 999; do
  > dune exec -- ono concrete gui.wat --steps=3 --seed=$seed --use-graphical-window=false
  > done
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  ed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  ed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  ed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  ed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>

Test --use-graphical-window=false sur plusieurs steps :
  $ for steps in 0 1 2 5 10; do
  > dune exec -- ono concrete gui.wat --steps=$steps --seed=1 --use-graphical-window=false
  > done
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  OK!
  File ".", line 1, characters 0-0:
  Warning: No dune-project file has been found in directory ".". A default one
  is assumed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  ed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  ed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
  ed but the project might break when dune is upgraded. Please create a
  dune-project file.
  Hint: generate the project file with: $ dune init project <name>
