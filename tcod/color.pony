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

