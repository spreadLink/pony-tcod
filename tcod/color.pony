use "assert"

//use "path:/usr/local/lib"
use "lib:tcod"

// declare c-stuff:
use @TCOD_color_RGB[Color](r: U8, g: U8, b: U8)
use @TCOD_color_HSV[Color](h: F32, s: F32, v: F32)
use @TCOD_color_equals[Bool](c1: Color box, c2: Color box)
use @TCOD_color_add[Color](c1: Color box, c2: Color box)
use @TCOD_color_subtract[Color](c1: Color box, c2: Color box)
use @TCOD_color_multiply[Color](c1: Color box, c2: Color box)
use @TCOD_color_multiply_scalar[Color](c1: Color box, value: F32)
use @TCOD_color_lerp[Color](c1: Color box, c2: Color box, coef: F32)

use @TCOD_color_set_HSV[None](c1: Pointer[Color] tag, h: F32, s: F32, v: F32)
use @TCOD_color_get_HSV[None](c1: Color box, h: Pointer[F32], s: Pointer[F32], v: Pointer[F32])
use @TCOD_color_get_hue[F32](c1: Color box)
use @TCOD_color_set_hue[None](c1: Pointer[Color] tag, h: F32)
use @TCOD_color_get_saturation[F32](c1: Color box)
use @TCOD_color_set_saturation[None](c1: Pointer[Color] tag, s: F32)
use @TCOD_color_get_value[F32](c1: Color box)
use @TCOD_color_set_value[None](c1: Pointer[Color] tag, v: F32)
use @TCOD_color_shift_hue[None](c1: Pointer[Color] tag, hshift: F32)
use @TCOD_color_scale_HSV[None](c1: Pointer[Color] tag, s_coef: F32, v_coef: F32)

use @TCOD_color_gen_map[None](map: Pointer[Color] tag, nb_key: USize,
  key_color: Pointer[Color] tag, key_index: Pointer[I32] tag)


// colour:
struct Color
  """
  Represents a primitive C-struct with a red, a green and a blue component.
  """
  var r: U8 = 0
  var g: U8 = 0
  var b: U8 = 0

  new create(red: U8, green: U8, blue: U8) =>
    @TCOD_color_RGB(red, green, blue)

  new from_HSV(hue: F32, saturation: F32, value: F32) =>
    """`saturation` and `value` are clamped between 0 and 1"""
    @TCOD_color_HSV(hue, saturation, value)

  fun equals(other: Color box): Bool =>
    @TCOD_color_equals(this, other)

  fun box eq(other: Color box): Bool =>
    this.equals(other)

  fun box ne(other: Color box): Bool =>
    not this.equals(other)

  fun box add(other: Color box): Color =>
    @TCOD_color_add(this, other)

  fun box subtract(other: Color box): Color =>
    @TCOD_color_subtract(this, other)

  fun box sub(other: Color box): Color =>
    this.subtract(other)

  fun box multiply(other: Color box): Color =>
    @TCOD_color_multiply(this, other)

  fun box multiply_scalar(value: F32): Color =>
    @TCOD_color_multiply_scalar(this, value)
  
  fun box mul(other: Color): Color =>
    this.multiply(other)

  fun box lerp(other: Color box, coef: F32): Color =>
    """Linearly interpolates two colours"""
    @TCOD_color_lerp(this, other, coef)

  fun ref set_HSV(hue: F32, saturation: F32, value: F32) =>
    """
    Modifies `this` by calculating and setting the RGB-values from the HSV-values.
    `saturation` and `value` are clamped between 0 and 1
    """
    var t = this
    @TCOD_color_set_HSV(addressof t, hue, saturation, value)

  fun box get_HSV(): (F32, F32, F32) =>
    var h: F32 = 0.0
    var s: F32 = 0.0
    var v: F32 = 0.0
    @TCOD_color_get_HSV(this, addressof h, addressof s, addressof v)
    (h, s, v)

  fun box get_hue(): F32 =>
    @TCOD_color_get_hue(this)

  fun ref set_hue(hue: F32) =>
    var t = this
    @TCOD_color_set_hue(addressof t, hue)

  fun box get_saturation(): F32 =>
    @TCOD_color_get_saturation(this)

  fun ref set_saturation(saturation: F32) =>
    """`saturation` is clamped between 0 and 1"""
    var t = this
    @TCOD_color_set_saturation(addressof t, saturation)

  fun box get_value(): F32 =>
    @TCOD_color_get_value(this)

  fun ref set_value(value: F32) =>
    """`value` is clamped between 0 and 1"""
    var t = this
    @TCOD_color_set_value(addressof t, value)

  fun ref shift_hue(hshift: F32) =>
    """Shifts the hue by `hshift` degrees"""
    var t = this
    @TCOD_color_shift_hue(addressof t, hshift)

  fun ref scale_HSV(saturation_coef: F32, value_coef: F32) =>
    var t = this
    @TCOD_color_scale_HSV(addressof t, saturation_coef, value_coef)

    
primitive Colors
  fun gen_map (colors: Array[Color], indices: Array[I32]): Array[Color]? =>
    """
    Generates a gradiant. The `colours` will be interpolated between the `indices`. 
    The last index defines the total size of the result array.
    """
    let nb_key = colors.size()
    Assert(nb_key == indices.size(), "'colors' and 'indices' must be of same length!")?
    let body = Array[Color](indices(nb_key - 1)?.usize() + 1)
    @TCOD_color_gen_map(body.cpointer(), nb_key,
      colors.cpointer(), indices.cpointer())
    body
  
  /* color values */
  fun black() => Color(0,0,0)
  fun darkest_grey() => Color(31,31,31)
  fun darker_grey() => Color(63,63,63)
  fun dark_grey() => Color(95,95,95)
  fun grey() => Color(127,127,127)
  fun light_grey() => Color(159,159,159)
  fun lighter_grey() => Color(191,191,191)
  fun lightest_grey() => Color(223,223,223)
  fun white() => Color(255,255,255)

  fun darkest_sepia() => Color(31,24,15)
  fun darker_sepia() => Color(63,50,31)
  fun dark_sepia() => Color(94,75,47)
  fun sepia() => Color(127,101,63)
  fun light_sepia() => Color(158,134,100)
  fun lighter_sepia() => Color(191,171,143)
  fun lightest_sepia() => Color(222,211,195)

  /* desaturated */
  fun desaturated_red() => Color(127,63,63)
  fun desaturated_flame() => Color(127,79,63)
  fun desaturated_orange() => Color(127,95,63)
  fun desaturated_amber() => Color(127,111,63)
  fun desaturated_yellow() => Color(127,127,63)
  fun desaturated_lime() => Color(111,127,63)
  fun desaturated_chartreuse() => Color(95,127,63)
  fun desaturated_green() => Color(63,127,63)
  fun desaturated_sea() => Color(63,127,95)
  fun desaturated_turquoise() => Color(63,127,111)
  fun desaturated_cyan() => Color(63,127,127)
  fun desaturated_sky() => Color(63,111,127)
  fun desaturated_azure() => Color(63,95,127)
  fun desaturated_blue() => Color(63,63,127)
  fun desaturated_han() => Color(79,63,127)
  fun desaturated_violet() => Color(95,63,127)
  fun desaturated_purple() => Color(111,63,127)
  fun desaturated_fuchsia() => Color(127,63,127)
  fun desaturated_magenta() => Color(127,63,111)
  fun desaturated_pink() => Color(127,63,95)
  fun desaturated_crimson() => Color(127,63,79)

  /* lightest */
  fun lightest_red() => Color(255,191,191)
  fun lightest_flame() => Color(255,207,191)
  fun lightest_orange() => Color(255,223,191)
  fun lightest_amber() => Color(255,239,191)
  fun lightest_yellow() => Color(255,255,191)
  fun lightest_lime() => Color(239,255,191)
  fun lightest_chartreuse() => Color(223,255,191)
  fun lightest_green() => Color(191,255,191)
  fun lightest_sea() => Color(191,255,223)
  fun lightest_turquoise() => Color(191,255,239)
  fun lightest_cyan() => Color(191,255,255)
  fun lightest_sky() => Color(191,239,255)
  fun lightest_azure() => Color(191,223,255)
  fun lightest_blue() => Color(191,191,255)
  fun lightest_han() => Color(207,191,255)
  fun lightest_violet() => Color(223,191,255)
  fun lightest_purple() => Color(239,191,255)
  fun lightest_fuchsia() => Color(255,191,255)
  fun lightest_magenta() => Color(255,191,239)
  fun lightest_pink() => Color(255,191,223)
  fun lightest_crimson() => Color(255,191,207)

  /* lighter */
  fun lighter_red() => Color(255,127,127)
  fun lighter_flame() => Color(255,159,127)
  fun lighter_orange() => Color(255,191,127)
  fun lighter_amber() => Color(255,223,127)
  fun lighter_yellow() => Color(255,255,127)
  fun lighter_lime() => Color(223,255,127)
  fun lighter_chartreuse() => Color(191,255,127)
  fun lighter_green() => Color(127,255,127)
  fun lighter_sea() => Color(127,255,191)
  fun lighter_turquoise() => Color(127,255,223)
  fun lighter_cyan() => Color(127,255,255)
  fun lighter_sky() => Color(127,223,255)
  fun lighter_azure() => Color(127,191,255)
  fun lighter_blue() => Color(127,127,255)
  fun lighter_han() => Color(159,127,255)
  fun lighter_violet() => Color(191,127,255)
  fun lighter_purple() => Color(223,127,255)
  fun lighter_fuchsia() => Color(255,127,255)
  fun lighter_magenta() => Color(255,127,223)
  fun lighter_pink() => Color(255,127,191)
  fun lighter_crimson() => Color(255,127,159)

  /* light */
  fun light_red() => Color(255,63,63)
  fun light_flame() => Color(255,111,63)
  fun light_orange() => Color(255,159,63)
  fun light_amber() => Color(255,207,63)
  fun light_yellow() => Color(255,255,63)
  fun light_lime() => Color(207,255,63)
  fun light_chartreuse() => Color(159,255,63)
  fun light_green() => Color(63,255,63)
  fun light_sea() => Color(63,255,159)
  fun light_turquoise() => Color(63,255,207)
  fun light_cyan() => Color(63,255,255)
  fun light_sky() => Color(63,207,255)
  fun light_azure() => Color(63,159,255)
  fun light_blue() => Color(63,63,255)
  fun light_han() => Color(111,63,255)
  fun light_violet() => Color(159,63,255)
  fun light_purple() => Color(207,63,255)
  fun light_fuchsia() => Color(255,63,255)
  fun light_magenta() => Color(255,63,207)
  fun light_pink() => Color(255,63,159)
  fun light_crimson() => Color(255,63,111)

  /* normal */
  fun red() => Color(255,0,0)
  fun flame() => Color(255,63,0)
  fun orange() => Color(255,127,0)
  fun amber() => Color(255,191,0)
  fun yellow() => Color(255,255,0)
  fun lime() => Color(191,255,0)
  fun chartreuse() => Color(127,255,0)
  fun green() => Color(0,255,0)
  fun sea() => Color(0,255,127)
  fun turquoise() => Color(0,255,191)
  fun cyan() => Color(0,255,255)
  fun sky() => Color(0,191,255)
  fun azure() => Color(0,127,255)
  fun blue() => Color(0,0,255)
  fun han() => Color(63,0,255)
  fun violet() => Color(127,0,255)
  fun purple() => Color(191,0,255)
  fun fuchsia() => Color(255,0,255)
  fun magenta() => Color(255,0,191)
  fun pink() => Color(255,0,127)
  fun crimson() => Color(255,0,63)

  /* dark */
  fun dark_red() => Color(191,0,0)
  fun dark_flame() => Color(191,47,0)
  fun dark_orange() => Color(191,95,0)
  fun dark_amber() => Color(191,143,0)
  fun dark_yellow() => Color(191,191,0)
  fun dark_lime() => Color(143,191,0)
  fun dark_chartreuse() => Color(95,191,0)
  fun dark_green() => Color(0,191,0)
  fun dark_sea() => Color(0,191,95)
  fun dark_turquoise() => Color(0,191,143)
  fun dark_cyan() => Color(0,191,191)
  fun dark_sky() => Color(0,143,191)
  fun dark_azure() => Color(0,95,191)
  fun dark_blue() => Color(0,0,191)
  fun dark_han() => Color(47,0,191)
  fun dark_violet() => Color(95,0,191)
  fun dark_purple() => Color(143,0,191)
  fun dark_fuchsia() => Color(191,0,191)
  fun dark_magenta() => Color(191,0,143)
  fun dark_pink() => Color(191,0,95)
  fun dark_crimson() => Color(191,0,47)

  /* darker */
  fun darker_red() => Color(127,0,0)
  fun darker_flame() => Color(127,31,0)
  fun darker_orange() => Color(127,63,0)
  fun darker_amber() => Color(127,95,0)
  fun darker_yellow() => Color(127,127,0)
  fun darker_lime() => Color(95,127,0)
  fun darker_chartreuse() => Color(63,127,0)
  fun darker_green() => Color(0,127,0)
  fun darker_sea() => Color(0,127,63)
  fun darker_turquoise() => Color(0,127,95)
  fun darker_cyan() => Color(0,127,127)
  fun darker_sky() => Color(0,95,127)
  fun darker_azure() => Color(0,63,127)
  fun darker_blue() => Color(0,0,127)
  fun darker_han() => Color(31,0,127)
  fun darker_violet() => Color(63,0,127)
  fun darker_purple() => Color(95,0,127)
  fun darker_fuchsia() => Color(127,0,127)
  fun darker_magenta() => Color(127,0,95)
  fun darker_pink() => Color(127,0,63)
  fun darker_crimson() => Color(127,0,31)

  /* darkest */
  fun darkest_red() => Color(63,0,0)
  fun darkest_flame() => Color(63,15,0)
  fun darkest_orange() => Color(63,31,0)
  fun darkest_amber() => Color(63,47,0)
  fun darkest_yellow() => Color(63,63,0)
  fun darkest_lime() => Color(47,63,0)
  fun darkest_chartreuse() => Color(31,63,0)
  fun darkest_green() => Color(0,63,0)
  fun darkest_sea() => Color(0,63,31)
  fun darkest_turquoise() => Color(0,63,47)
  fun darkest_cyan() => Color(0,63,63)
  fun darkest_sky() => Color(0,47,63)
  fun darkest_azure() => Color(0,31,63)
  fun darkest_blue() => Color(0,0,63)
  fun darkest_han() => Color(15,0,63)
  fun darkest_violet() => Color(31,0,63)
  fun darkest_purple() => Color(47,0,63)
  fun darkest_fuchsia() => Color(63,0,63)
  fun darkest_magenta() => Color(63,0,47)
  fun darkest_pink() => Color(63,0,31)
  fun darkest_crimson() => Color(63,0,15)

  /* metallic */
  fun brass() => Color(191,151,96)
  fun copper() => Color(197,136,124)
  fun gold() => Color(229,191,0)
  fun silver() => Color(203,203,203)

  /* miscellaneous */
  fun celadon() => Color(172,255,175)
  fun peach() => Color(255,159,127)
