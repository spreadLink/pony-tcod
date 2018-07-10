primitive Keycode
	fun none(): I32 => 0
	fun escape(): I32 => 1
	fun backspace(): I32 => 2
	fun tab(): I32 => 3
	fun enter(): I32 => 4
	fun shift(): I32 => 5
	fun control(): I32 => 6
	fun alt(): I32 => 7
	fun pause(): I32 => 8
	fun capslock(): I32 => 9
	fun pageup(): I32 => 10
	fun pagedown(): I32 => 11
	fun endkey(): I32 => 12
	fun home(): I32 => 13
	fun up(): I32 => 14
	fun left(): I32 => 15
	fun right(): I32 => 16
	fun down(): I32 => 17
	fun printscreen(): I32 => 18
	fun insert(): I32 => 19
	fun delete(): I32 => 20
	fun lwin(): I32 => 21
	fun rwin(): I32 => 22
	fun apps(): I32 => 23
	fun nr0(): I32 => 24
	fun nr1(): I32 => 25
	fun nr2(): I32 => 26
	fun nr3(): I32 => 27
	fun nr4(): I32 => 28
	fun nr5(): I32 => 29
	fun nr6(): I32 => 30
	fun nr7(): I32 => 31
	fun nr8(): I32 => 32
	fun nr9(): I32 => 33
	fun kp0(): I32 => 34
	fun kp1(): I32 => 35
	fun kp2(): I32 => 36
	fun kp3(): I32 => 37
	fun kp4(): I32 => 38
	fun kp5(): I32 => 39
	fun kp6(): I32 => 40
	fun kp7(): I32 => 41
	fun kp8(): I32 => 42
	fun kp9(): I32 => 43
	fun kpadd(): I32 => 44
	fun kpsub(): I32 => 45
	fun kpdiv(): I32 => 46
	fun kpmul(): I32 => 47
	fun kpdec(): I32 => 48
	fun kpenter(): I32 => 49
	fun f1(): I32 => 50
	fun f2(): I32 => 51
	fun f3(): I32 => 52
	fun f4(): I32 => 53
	fun f5(): I32 => 54
	fun f6(): I32 => 55
	fun f7(): I32 => 56
	fun f8(): I32 => 57
	fun f9(): I32 => 58
	fun f10(): I32 => 59
	fun f11(): I32 => 60
	fun f12(): I32 => 61
	fun numlock(): I32 => 62
	fun scrolllock(): I32 => 63
	fun space(): I32 => 64
	fun char(): I32 => 65
	fun text(): I32 => 66

    
struct Key
	var vk: I32 = Keycode.none()
	var c: U8 = 0 // Not 0 if vk = Keycode.char()
	var text: Pointer[U8] = Pointer[U8].create() // Only meaningful if vk = Keycode.text(); otherwise the first element is null
	var pressed: Bool = false
	var lalt: Bool = false
	var lctrl: Bool = false
	var lmeta: Bool = false
	var ralt: Bool = false
	var rctrl: Bool = false
	var rmeta: Bool = false
	var shift: Bool = false

primitive Chars
  /* single walls */
	fun hline(): I32 => 196
	fun vline(): I32 => 179
	fun ne(): I32 => 191
	fun nw(): I32 => 218
	fun se(): I32 => 217
	fun sw(): I32 => 192
	fun teew(): I32 => 180
	fun teee(): I32 => 195
	fun teen(): I32 => 193
	fun tees(): I32 => 194
	fun cross(): I32 => 197
	/* double walls */
	fun dhline(): I32 => 205
	fun dvline(): I32 => 186
	fun dne(): I32 => 187
	fun dnw(): I32 => 201
	fun dse(): I32 => 188
	fun dsw(): I32 => 200
	fun dteew(): I32 => 185
	fun dteee(): I32 => 204
	fun dteen(): I32 => 202
	fun dtees(): I32 => 203
	fun dcross(): I32 => 206
	/* blocks */
	fun block1(): I32 => 176
	fun block2(): I32 => 177
	fun block3(): I32 => 178
	/* arrows */
	fun arrow_n(): I32 => 24
	fun arrow_s(): I32 => 25
	fun arrow_e(): I32 => 26
	fun arrow_w(): I32 => 27
	/* arrows without tail */
	fun arrow2_n(): I32 => 30
	fun arrow2_s(): I32 => 31
	fun arrow2_e(): I32 => 16
	fun arrow2_w(): I32 => 17
	/* double arrows */
	fun darrow_h(): I32 => 29
	fun darrow_v(): I32 => 18
	/* GUI stuff */
	fun checkbox_unset(): I32 => 224
	fun checkbox_set(): I32 => 225
	fun radio_unset(): I32 => 9
	fun radio_set(): I32 => 10
	/* sub-pixel resolution kit */
	fun subp_nw(): I32 => 226
	fun subp_ne(): I32 => 227
	fun subp_n(): I32 => 228
	fun subp_se(): I32 => 229
	fun subp_diag(): I32 => 230
	fun subp_e(): I32 => 231
	fun subp_sw(): I32 => 232
	/* miscellaneous */
	fun smilie(): I32 =>  1
	fun smilie_inv(): I32 =>  2
	fun heart(): I32 =>  3
	fun diamond(): I32 =>  4
	fun club(): I32 =>  5
	fun spade(): I32 =>  6
	fun bullet(): I32 =>  7
	fun bullet_inv(): I32 =>  8
	fun male(): I32 =>  11
	fun female(): I32 =>  12
	fun note(): I32 =>  13
	fun note_double(): I32 =>  14
	fun light(): I32 =>  15
	fun exclam_double(): I32 =>  19
	fun pilcrow(): I32 =>  20
	fun section(): I32 =>  21
	fun pound(): I32 =>  156
	fun multiplication(): I32 =>  158
	fun function(): I32 =>  159
	fun reserved(): I32 =>  169
	fun half(): I32 =>  171
	fun one_quarter(): I32 =>  172
	fun copyright(): I32 =>  184
	fun cent(): I32 =>  189
	fun yen(): I32 =>  190
	fun currency(): I32 =>  207
	fun three_quarters(): I32 =>  243
	fun division(): I32 =>  246
	fun grade(): I32 =>  248
	fun umlaut(): I32 =>  249
	fun pow1(): I32 =>  251
	fun pow3(): I32 =>  252
	fun pow2(): I32 =>  253
	fun bullet_square(): I32 =>  254

    
primitive ColCtrl
	fun n1(): I32 => 1
	fun n2(): I32 => 2
	fun n3(): I32 => 3
	fun n4(): I32 => 4
	fun n5(): I32 => 5
	fun number(): I32 => 5
	fun fore_rgb(): I32 => 6
	fun back_rgb(): I32 => 7
	fun stop(): I32 => 8
    
primitive BkgndFlag 
	fun none(): I32 => 0
	fun set(): I32 => 1
	fun multiply(): I32 => 2
	fun lighten(): I32 => 3
	fun darken(): I32 => 4
	fun screen(): I32 => 5
	fun color_dodge(): I32 => 6
	fun color_burn(): I32 => 7
	fun add(): I32 => 8
	fun adda(): I32 => 9
	fun burn(): I32 => 10
	fun overlay(): I32 => 11
	fun alph(): I32 => 12
	fun default(): I32 => 13

primitive KeyStatus
	fun pressed(): I32 => 1
	fun released(): I32 => 2


primitive FontFlags
  """These form a bit-field and should be OR'ed together"""
  
  fun layout_incol(): I32 =>
   """Tiles arranged in column-major order"""
   1
 
  fun layout_inrow(): I32 =>
    """Tiles are arranged in row-major order"""
    2
    
  fun type_greyscale(): I32 =>
    """Converts tiles into monochrome gradient"""
    4
  fun type_grayscale(): I32 =>
    4

  fun layout_TCOD(): I32 =>
    """Used by some of libtcod's fonts"""
    8

    
primitive Renderer
  """Types of Renderer"""
 
  fun glsl(): I32 =>
    """OpenGL shader renderer"""
    0

  fun opengl(): I32 =>
    """shaderless OpenGL renderer; `glsl` should be preferred"""
    1
  /**
   *  A software based renderer.
   *
   *  The font file is loaded into RAM instead of VRAM in this implementation.
   */
  fun sdl(): I32 =>
    """Software renderer; Note: the font-file will be loaded into RAM instead of VRAM"""
    2
    
  fun nb(): I32 =>
    """Total amount of renderer available"""
    3

primitive Alignment
  """Justification Options"""
	fun left(): I32 => 0
	fun right(): I32 => 1
	fun center(): I32 => 2


 
struct ConsoleData
  var ch_array: Pointer[I32] = Pointer[I32].create() // Array of character codes
  var fg_array: Pointer[Color] = Pointer[Color].create() // Pointers to color arrays
  var bg_array: Pointer[Color] = Pointer[Color].create()
  var w: I32 = 0 // width in characters
  var h: I32 = 0 // height in characters
  var bkgnd_flag: I32 = BkgndFlag.none() // default background flag
  var alignment: I32 = Alignment.left() // default alignment
  var fore: Color = Color(0,0,0) // foreground
  var back: Color = Color(0,0,0) // background
  var has_key_color: Bool = false
  var key_color: Color = Color(0,0,0)
  
type Console is MaybePointer[ConsoleData]


