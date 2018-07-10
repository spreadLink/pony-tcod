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
  
  fun box mul(that: (Color | F32)): Color =>
    match that
      | let other: Color => this.multiply(other)
      | let value: F32 => this.multiply_scalar(value)
    end

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

    
primitive Gradiant
  fun generate (colors: Array[Color], indices: Array[I32]): Array[Color]? =>
    """
    Generates a gradiant. The `colours` will be interpolated between the `indices`. 
    The last index defines the total size of the result array.
    Same as TCOD_colors_gen_map.
    """
    let nb_key = colors.size()
    Assert(nb_key == indices.size(), "'colors' and 'indices' must be of same length!")?
    let body = Array[Color](indices(nb_key - 1)?.usize() + 1)
    @TCOD_color_gen_map(body.cpointer(), nb_key,
      colors.cpointer(), indices.cpointer())
    body

primitive Colors
  /* color values */
  fun black() => Color.from_RGB(0,0,0)
  fun darkest_grey() => Color.from_RGB(31,31,31)
  fun darker_grey() => Color.from_RGB(63,63,63)
  fun dark_grey() => Color.from_RGB(95,95,95)
  fun grey() => Color.from_RGB(127,127,127)
  fun light_grey() => Color.from_RGB(159,159,159)
  fun lighter_grey() => Color.from_RGB(191,191,191)
  fun lightest_grey() => Color.from_RGB(223,223,223)
  fun white() => Color.from_RGB(255,255,255)

  fun darkest_sepia() => Color.from_RGB(31,24,15)
  fun darker_sepia() => Color.from_RGB(63,50,31)
  fun dark_sepia() => Color.from_RGB(94,75,47)
  fun sepia() => Color.from_RGB(127,101,63)
  fun light_sepia() => Color.from_RGB(158,134,100)
  fun lighter_sepia() => Color.from_RGB(191,171,143)
  fun lightest_sepia() => Color.from_RGB(222,211,195)

  /* desaturated */
  fun desaturated_red() => Color.from_RGB(127,63,63)
  fun desaturated_flame() => Color.from_RGB(127,79,63)
  fun desaturated_orange() => Color.from_RGB(127,95,63)
  fun desaturated_amber() => Color.from_RGB(127,111,63)
  fun desaturated_yellow() => Color.from_RGB(127,127,63)
  fun desaturated_lime() => Color.from_RGB(111,127,63)
  fun desaturated_chartreuse() => Color.from_RGB(95,127,63)
  fun desaturated_green() => Color.from_RGB(63,127,63)
  fun desaturated_sea() => Color.from_RGB(63,127,95)
  fun desaturated_turquoise() => Color.from_RGB(63,127,111)
  fun desaturated_cyan() => Color.from_RGB(63,127,127)
  fun desaturated_sky() => Color.from_RGB(63,111,127)
  fun desaturated_azure() => Color.from_RGB(63,95,127)
  fun desaturated_blue() => Color.from_RGB(63,63,127)
  fun desaturated_han() => Color.from_RGB(79,63,127)
  fun desaturated_violet() => Color.from_RGB(95,63,127)
  fun desaturated_purple() => Color.from_RGB(111,63,127)
  fun desaturated_fuchsia() => Color.from_RGB(127,63,127)
  fun desaturated_magenta() => Color.from_RGB(127,63,111)
  fun desaturated_pink() => Color.from_RGB(127,63,95)
  fun desaturated_crimson() => Color.from_RGB(127,63,79)

  /* lightest */
  fun lightest_red() => Color.from_RGB(255,191,191)
  fun lightest_flame() => Color.from_RGB(255,207,191)
  fun lightest_orange() => Color.from_RGB(255,223,191)
  fun lightest_amber() => Color.from_RGB(255,239,191)
  fun lightest_yellow() => Color.from_RGB(255,255,191)
  fun lightest_lime() => Color.from_RGB(239,255,191)
  fun lightest_chartreuse() => Color.from_RGB(223,255,191)
  fun lightest_green() => Color.from_RGB(191,255,191)
  fun lightest_sea() => Color.from_RGB(191,255,223)
  fun lightest_turquoise() => Color.from_RGB(191,255,239)
  fun lightest_cyan() => Color.from_RGB(191,255,255)
  fun lightest_sky() => Color.from_RGB(191,239,255)
  fun lightest_azure() => Color.from_RGB(191,223,255)
  fun lightest_blue() => Color.from_RGB(191,191,255)
  fun lightest_han() => Color.from_RGB(207,191,255)
  fun lightest_violet() => Color.from_RGB(223,191,255)
  fun lightest_purple() => Color.from_RGB(239,191,255)
  fun lightest_fuchsia() => Color.from_RGB(255,191,255)
  fun lightest_magenta() => Color.from_RGB(255,191,239)
  fun lightest_pink() => Color.from_RGB(255,191,223)
  fun lightest_crimson() => Color.from_RGB(255,191,207)

  /* lighter */
  fun lighter_red() => Color.from_RGB(255,127,127)
  fun lighter_flame() => Color.from_RGB(255,159,127)
  fun lighter_orange() => Color.from_RGB(255,191,127)
  fun lighter_amber() => Color.from_RGB(255,223,127)
  fun lighter_yellow() => Color.from_RGB(255,255,127)
  fun lighter_lime() => Color.from_RGB(223,255,127)
  fun lighter_chartreuse() => Color.from_RGB(191,255,127)
  fun lighter_green() => Color.from_RBG(127,255,127)
  fun lighter_sea() => Color.from_RGB(127,255,191)
  fun lighter_turquoise() => Color.from_RGB(127,255,223)
  fun lighter_cyan() => Color.from_RGB(127,255,255)
  fun lighter_sky() => Color.from_RGB(127,223,255)
  fun lighter_azure() => Color.from_RGB(127,191,255)
  fun lighter_blue() => Color.from_RGB(127,127,255)
  fun lighter_han() => Color.from_RGB(159,127,255)
  fun lighter_violet() => Color.from_RGB(191,127,255)
  fun lighter_purple() => Color.from_RGB(223,127,255)
  fun lighter_fuchsia() => Color.from_RGB(255,127,255)
  fun lighter_magenta() => Color.from_RGB(255,127,223)
  fun lighter_pink() => Color.from_RGB(255,127,191)
  fun lighter_crimson() => Color.from_RGB(255,127,159)

  /* light */
  fun light_red() => Color.from_RGB(255,63,63)
  fun light_flame() => Color.from_RGB(255,111,63)
  fun light_orange() => Color.from_RGB(255,159,63)
  fun light_amber() => Color.from_RGB(255,207,63)
  fun light_yellow() => Color.from_RGB(255,255,63)
  fun light_lime() => Color.from_RGB(207,255,63)
  fun light_chartreuse() => Color.from_RGB(159,255,63)
  fun light_green() => Color.from_RGB(63,255,63)
  fun light_sea() => Color.from_RGB(63,255,159)
  fun light_turquoise() => Color.from_RGB(63,255,207)
  fun light_cyan() => Color.from_RGB(63,255,255)
  fun light_sky() => Color.from_RGB(63,207,255)
  fun light_azure() => Color.from_RGB(63,159,255)
  fun light_blue() => Color.from_RGB(63,63,255)
  fun light_han() => Color.from_RGB(111,63,255)
  fun light_violet() => Color.from_RGB(159,63,255)
  fun light_purple() => Color.from_RGB(207,63,255)
  fun light_fuchsia() => Color.from_RGB(255,63,255)
  fun light_magenta() => Color.from_RGB(255,63,207)
  fun light_pink() => Color.from_RGB(255,63,159)
  fun light_crimson() => Color.from_RGB(255,63,111)

  /* normal */
  fun red() => Color.from_RGB(255,0,0)
  fun flame() => Color.from_RGB(255,63,0)
  fun orange() => Color.from_RGB(255,127,0)
  fun amber() => Color.from_RGB(255,191,0)
  fun yellow() => Color.from_RGB(255,255,0)
  fun lime() => Color.from_RGB(191,255,0)
  fun chartreuse() => Color.from_RGB(127,255,0)
  fun green() => Color.from_RGB(0,255,0)
  fun sea() => Color.from_RGB(0,255,127)
  fun turquoise() => Color.from_RGB(0,255,191)
  fun cyan() => Color.from_RGB(0,255,255)
  fun sky() => Color.from_RGB(0,191,255)
  fun azure() => Color.from_RGB(0,127,255)
  fun blue() => Color.from_RGB(0,0,255)
  fun han() => Color.from_RGB(63,0,255)
  fun violet() => Color.from_RGB(127,0,255)
  fun purple() => Color.from_RGB(191,0,255)
  fun fuchsia() => Color.from_RGB(255,0,255)
  fun magenta() => Color.from_RGB(255,0,191)
  fun pink() => Color.from_RGB(255,0,127)
  fun crimson() => Color.from_RGB(255,0,63)

  /* dark */
  fun dark_red() => Color.from_RGB(191,0,0)
  fun dark_flame() => Color.from_RGB(191,47,0)
  fun dark_orange() => Color.from_RGB(191,95,0)
  fun dark_amber() => Color.from_RGB(191,143,0)
  fun dark_yellow() => Color.from_RGB(191,191,0)
  fun dark_lime() => Color.from_RGB(143,191,0)
  fun dark_chartreuse() => Color.from_RGB(95,191,0)
  fun dark_green() => Color.from_RGB(0,191,0)
  fun dark_sea() => Color.from_RGB(0,191,95)
  fun dark_turquoise() => Color.from_RGB(0,191,143)
  fun dark_cyan() => Color.from_RGB(0,191,191)
  fun dark_sky() => Color.from_RGB(0,143,191)
  fun dark_azure() => Color.from_RGB(0,95,191)
  fun dark_blue() => Color.from_RGB(0,0,191)
  fun dark_han() => Color.from_RGB(47,0,191)
  fun dark_violet() => Color.from_RGB(95,0,191)
  fun dark_purple() => Color.from_RGB(143,0,191)
  fun dark_fuchsia() => Color.from_RGB(191,0,191)
  fun dark_magenta() => Color.from_RGB(191,0,143)
  fun dark_pink() => Color.from_RGB(191,0,95)
  fun dark_crimson() => Color.from_RGB(191,0,47)

  /* darker */
  fun darker_red() => Color.from_RGB(127,0,0)
  fun darker_flame() => Color.from_RGB(127,31,0)
  fun darker_orange() => Color.from_RGB(127,63,0)
  fun darker_amber() => Color.from_RGB(127,95,0)
  fun darker_yellow() => Color.from_RGB(127,127,0)
  fun darker_lime() => Color.from_RGB(95,127,0)
  fun darker_chartreuse() => Color.from_RGB(63,127,0)
  fun darker_green() => Color.from_RGB(0,127,0)
  fun darker_sea() => Color.from_RGB(0,127,63)
  fun darker_turquoise() => Color.from_RGB(0,127,95)
  fun darker_cyan() => Color.from_RGB(0,127,127)
  fun darker_sky() => Color.from_RGB(0,95,127)
  fun darker_azure() => Color.from_RGB(0,63,127)
  fun darker_blue() => Color.from_RGB(0,0,127)
  fun darker_han() => Color.from_RGB(31,0,127)
  fun darker_violet() => Color.from_RGB(63,0,127)
  fun darker_purple() => Color.from_RGB(95,0,127)
  fun darker_fuchsia() => Color.from_RGB(127,0,127)
  fun darker_magenta() => Color.from_RGB(127,0,95)
  fun darker_pink() => Color.from_RGB(127,0,63)
  fun darker_crimson() => Color.from_RGB(127,0,31)

  /* darkest */
  fun darkest_red() => Color.from_RGB(63,0,0)
  fun darkest_flame() => Color.from_RGB(63,15,0)
  fun darkest_orange() => Color.from_RGB(63,31,0)
  fun darkest_amber() => Color.from_RGB(63,47,0)
  fun darkest_yellow() => Color.from_RGB(63,63,0)
  fun darkest_lime() => Color.from_RGB(47,63,0)
  fun darkest_chartreuse() => Color.from_RGB(31,63,0)
  fun darkest_green() => Color.from_RGB(0,63,0)
  fun darkest_sea() => Color.from_RGB(0,63,31)
  fun darkest_turquoise() => Color.from_RGB(0,63,47)
  fun darkest_cyan() => Color.from_RGB(0,63,63)
  fun darkest_sky() => Color.from_RGB(0,47,63)
  fun darkest_azure() => Color.from_RGB(0,31,63)
  fun darkest_blue() => Color.from_RGB(0,0,63)
  fun darkest_han() => Color.from_RGB(15,0,63)
  fun darkest_violet() => Color.from_RGB(31,0,63)
  fun darkest_purple() => Color.from_RGB(47,0,63)
  fun darkest_fuchsia() => Color.from_RGB(63,0,63)
  fun darkest_magenta() => Color.from_RGB(63,0,47)
  fun darkest_pink() => Color.from_RGB(63,0,31)
  fun darkest_crimson() => Color.from_RGB(63,0,15)

  /* metallic */
  fun brass() => Color.from_RGB(191,151,96)
  fun copper() => Color.from_RGB(197,136,124)
  fun gold() => Color.from_RGB(229,191,0)
  fun silver() => Color.from_RGB(203,203,203)

  /* miscellaneous */
  fun celadon() => Color.from_RGB(172,255,175)
  fun peach() => Color.from_RGB(255,159,127)
