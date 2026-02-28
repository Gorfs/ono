Test the output of the man page:
  $ ono symbolic --help=plain
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
  NAME
         ono-symbolic
  
  SYNOPSIS
         ono symbolic [--no-stop-at-failure] [OPTION]… FILE
  
  ARGUMENTS
         FILE (required)
             Source file to analyze.
  
  OPTIONS
         --no-stop-at-failure
             Don't stop at the first failure, but continue to explore.
  
  COMMON OPTIONS
         --color=WHEN (absent=auto)
             Colorize the output. WHEN must be one of auto, always or never.
  
         --help[=FMT] (default=auto)
             Show this help in format FMT. The value FMT must be one of auto,
             pager, groff or plain. With auto, the format is pager or plain
             whenever the TERM env var is dumb or undefined.
  
         -q, --quiet
             Be quiet. Takes over -v and --verbosity.
  
         -v, --verbose
             Increase verbosity. Repeatable, but more than twice does not bring
             more.
  
         --verbosity=LEVEL (absent=warning or ONO_VERBOSITY env)
             Be more or less verbose. LEVEL must be one of quiet, error,
             warning, info or debug. Takes over -v.
  
         --version
             Show version information.
  
  EXIT STATUS
         ono symbolic exits with:
  
         0   on success.
  
         1   on conversion to integer error in Wasm code.
  
         2   on unreachable instruction in Wasm code.
  
         3   on division by zero in Wasm code.
  
         4   on integer overflow in Wasm code.
  
         5   on stack overflow in Wasm code.
  
         6   on out of bounds memory access in Wasm code.
  
         123 on indiscriminate errors reported on standard error.
  
         124 on command line parsing errors.
  
         125 on unexpected internal errors (bugs).
  
  ENVIRONMENT
         These environment variables affect the execution of ono symbolic:
  
         ONO_VERBOSITY
             See option --verbosity.
  
  SEE ALSO
         ono(1)
  
























