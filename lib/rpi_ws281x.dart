import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart'; // needed for Utf8

import 'dart:io' show Platform;
import 'package:path/path.dart' as p;

typedef new_ws2811_t_func = ffi.Pointer<ffi.Void> Function();
typedef NewWS2811 = ffi.Pointer<ffi.Void> Function();

typedef delete_ws2811_t_func = ffi.Void Function(ffi.Pointer<ffi.Void> ws);
typedef DeleteWS2811 = void Function(ffi.Pointer<ffi.Void> ws);

typedef ws2811_init_func = ffi.Int32 Function(ffi.Pointer<ffi.Void> ws);
typedef WS2811_Init = int Function(ffi.Pointer<ffi.Void> ws);

typedef ws2811_render_func = ffi.Int32 Function(ffi.Pointer<ffi.Void> ws);
typedef WS2811_Render = int Function(ffi.Pointer<ffi.Void> ws);

typedef ws2811_set_freq_func = ffi.Void Function(ffi.Pointer<ffi.Void> ws, ffi.Int32 freq_hz);
typedef WS2811_SetFreq = void Function(ffi.Pointer<ffi.Void> ws, int freq_hz);

typedef ws2811_set_dmanum_func = ffi.Void Function(ffi.Pointer<ffi.Void> ws, ffi.Int32 dma);
typedef WS2811_SetDmaNum = void Function(ffi.Pointer<ffi.Void> ws, int dma);

typedef ws2811_channel_t_func = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void> ws, ffi.Int32 channelnum);
typedef WS2811_Channel = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void> ws, int channelnum);

typedef ws2811_set_count_func = ffi.Void Function(ffi.Pointer<ffi.Void> channel, ffi.Int32 count);
typedef WS2811_SetCount = void Function(ffi.Pointer<ffi.Void> channel, int count);

typedef ws2811_get_count_func = ffi.Int32 Function(ffi.Pointer<ffi.Void> channel);
typedef WS2811_GetCount = int Function(ffi.Pointer<ffi.Void> channel);

typedef ws2811_set_gpionum_func = ffi.Void Function(ffi.Pointer<ffi.Void> channel, ffi.Int32 gpionum);
typedef WS2811_SetGpioNum = void Function(ffi.Pointer<ffi.Void> channel, int gpionum);

typedef ws2811_set_invert_func = ffi.Void Function(ffi.Pointer<ffi.Void> channel, ffi.Int32 invert);
typedef WS2811_SetInvert = void Function(ffi.Pointer<ffi.Void> channel, int invert);

typedef ws2811_set_brightness_func = ffi.Void Function(ffi.Pointer<ffi.Void> channel, ffi.Int32 brightness);
typedef WS2811_SetBrightness = void Function(ffi.Pointer<ffi.Void> channel, int brightness);

typedef ws2811_get_brightness_func = ffi.Int32 Function(ffi.Pointer<ffi.Void> channel);
typedef WS2811_GetBrightness = int Function(ffi.Pointer<ffi.Void> channel);

typedef ws2811_set_strip_type_func = ffi.Void Function(ffi.Pointer<ffi.Void> channel, ffi.Int32 strip_type);
typedef WS2811_SetStripType = void Function(ffi.Pointer<ffi.Void> channel, int stripType);

typedef ws2811_set_led_func = ffi.Int32 Function(ffi.Pointer<ffi.Void> channel, ffi.Int32 lednum, ffi.Uint32 color);
typedef WS2811_SetLed = int Function(ffi.Pointer<ffi.Void> channel, int ledNum, int color);

typedef ws2811_get_led_func = ffi.Uint32 Function(ffi.Pointer<ffi.Void> channel, ffi.Int32 lednum);
typedef WS2811_GetLed = int Function(ffi.Pointer<ffi.Void> channel, int ledNum);

typedef ws2811_get_response_str_func = ffi.Pointer<Utf8> Function(ffi.Int32 resp);
typedef WS2811_GetResponse_str = ffi.Pointer<Utf8> Function(int resp);

// 4 color R, G, B and W ordering
const SK6812_STRIP_RGBW = 0x18100800;
const SK6812_STRIP_RBGW = 0x18100008;
const SK6812_STRIP_GRBW = 0x18081000;
const SK6812_STRIP_GBRW = 0x18080010;
const SK6812_STRIP_BRGW = 0x18001008;
const SK6812_STRIP_BGRW = 0x18000810;
const SK6812_SHIFT_WMASK = 0xf0000000;

// 3 color R, G and B ordering
const WS2811_STRIP_RGB = 0x00100800;
const WS2811_STRIP_RBG = 0x00100008;
const WS2811_STRIP_GRB = 0x00081000;
const WS2811_STRIP_GBR = 0x00080010;
const WS2811_STRIP_BRG = 0x00001008;
const WS2811_STRIP_BGR = 0x00000810;

// predefined fixed LED types
const WS2812_STRIP = WS2811_STRIP_GRB;
const SK6812_STRIP = WS2811_STRIP_GRB;
const SK6812W_STRIP = SK6812_STRIP_GRBW;

const int WS2811_SUCCESS = 0;

/// Convert the provided red, green, blue color to a 24-bit color value.
/// Each color component should be a value 0-255 where 0 is the lowest intensity
/// and 255 is the highest intensity.
int Color(int red, int green, int blue, [int white = 0]) {
  return (white << 24) | (red << 16) | (green << 8) | blue;
}

/// Class to represent a NeoPixel/WS281x LED display.
///
class WS281x {
  ffi.Pointer<ffi.Void> _leds;
  ffi.Pointer<ffi.Void> _channel;

  DeleteWS2811 deleteWS2811;
  WS2811_Init ws2811_Init;
  WS2811_Render ws2811_Render;
  WS2811_SetFreq ws2811_SetFreq;
  WS2811_SetDmaNum ws2811_SetDmaNum;
  WS2811_Channel ws2811_Channel;
  WS2811_SetCount ws2811_SetCount;
  WS2811_GetCount ws2811_GetCount;
  WS2811_SetGpioNum ws2811_SetGpioNum;
  WS2811_SetInvert ws2811_SetInvert;
  WS2811_SetBrightness ws2811_SetBrightness;
  WS2811_GetBrightness ws2811_GetBrightness;
  WS2811_SetStripType ws2811_SetStripType;
  WS2811_SetLed ws2811_SetLed;
  WS2811_GetLed ws2811_GetLed;
  WS2811_GetResponse_str ws2811_GetResponse_str;

  /// Class to represent a NeoPixel/WS281x LED display.
  ///
  /// [libPath] should be relative or absolute path to the libws2811wrap.so library.
  /// [num] should be the number of pixels in the display, and [pin] should be
  /// the GPIO pin connected to the display signal line (must be a PWM pin
  /// like 18!).  Optional parameters are [freq_hz], the frequency of the
  /// display signal in hertz (default 800khz), [dma], the DMA channel to use
  /// (default 10), [invert], a boolean specifying if the signal line should
  /// be inverted (default False), and [channel], the PWM channel to use
  /// (defaults to 0).
  WS281x(String libPath, int num, int pin, {int freq_hz=800000, int dma=10, bool invert=false,
          int brightness=255, int channel=0, int strip_type=WS2811_STRIP_RGB}) {

    final dylib = ffi.DynamicLibrary.open(libPath);
    // Look up the C functions
    final newWS2811 = dylib
        .lookup<ffi.NativeFunction<new_ws2811_t_func>>('new_ws2811_t')
        .asFunction<NewWS2811>();
    deleteWS2811 = dylib
        .lookup<ffi.NativeFunction<delete_ws2811_t_func>>('delete_ws2811_t')
        .asFunction<DeleteWS2811>();
    ws2811_Init = dylib
        .lookup<ffi.NativeFunction<ws2811_init_func>>('ws2811_init_strip')
        .asFunction<WS2811_Init>();
    ws2811_Render = dylib
        .lookup<ffi.NativeFunction<ws2811_render_func>>('ws2811_render_strip')
        .asFunction<WS2811_Render>();
    ws2811_SetFreq = dylib
        .lookup<ffi.NativeFunction<ws2811_set_freq_func>>('ws2811_set_freq')
        .asFunction<WS2811_SetFreq>();
    ws2811_SetDmaNum = dylib
        .lookup<ffi.NativeFunction<ws2811_set_dmanum_func>>('ws2811_set_dmanum')
        .asFunction<WS2811_SetDmaNum>();
    ws2811_Channel = dylib
        .lookup<ffi.NativeFunction<ws2811_channel_t_func>>('ws2811_get_channel')
        .asFunction<WS2811_Channel>();
    ws2811_SetCount = dylib
        .lookup<ffi.NativeFunction<ws2811_set_count_func>>('ws2811_set_count')
        .asFunction<WS2811_SetCount>();
    ws2811_GetCount = dylib
        .lookup<ffi.NativeFunction<ws2811_get_count_func>>('ws2811_get_count')
        .asFunction<WS2811_GetCount>();
    ws2811_SetGpioNum = dylib
        .lookup<ffi.NativeFunction<ws2811_set_gpionum_func>>('ws2811_set_gpionum')
        .asFunction<WS2811_SetGpioNum>();
    ws2811_SetInvert = dylib
        .lookup<ffi.NativeFunction<ws2811_set_invert_func>>('ws2811_set_invert')
        .asFunction<WS2811_SetInvert>();
    ws2811_SetBrightness = dylib
        .lookup<ffi.NativeFunction<ws2811_set_brightness_func>>('ws2811_set_brightness')
        .asFunction<WS2811_SetBrightness>();
    ws2811_GetBrightness = dylib
        .lookup<ffi.NativeFunction<ws2811_get_brightness_func>>('ws2811_get_brightness')
        .asFunction<WS2811_GetBrightness>();
    ws2811_SetStripType = dylib
        .lookup<ffi.NativeFunction<ws2811_set_strip_type_func>>('ws2811_set_strip_type')
        .asFunction<WS2811_SetStripType>();
    ws2811_SetLed = dylib
        .lookup<ffi.NativeFunction<ws2811_set_led_func>>('ws2811_set_led')
        .asFunction<WS2811_SetLed>();
    ws2811_GetLed = dylib
        .lookup<ffi.NativeFunction<ws2811_get_led_func>>('ws2811_get_led')
        .asFunction<WS2811_GetLed>();
    ws2811_GetResponse_str = dylib
        .lookup<ffi.NativeFunction<ws2811_get_response_str_func>>('ws2811_get_response_str')
        .asFunction<WS2811_GetResponse_str>();

    // Create ws2811_t structure and fill in parameters.
    _leds = newWS2811();

    // Initialize the channels to zero
    for (var channum=0; channum<2; channum++) {
      var chan = ws2811_Channel(_leds, channum);
      ws2811_SetCount(chan, 0);
      ws2811_SetGpioNum(chan, 0);
      ws2811_SetInvert(chan, 0);
      ws2811_SetBrightness(chan, 0);
    }

    // Initialize the channel in use
    _channel = ws2811_Channel(_leds, channel);
    ws2811_SetCount(_channel, num);
    ws2811_SetGpioNum(_channel, pin);
    ws2811_SetInvert(_channel, invert ? 1 : 0);
    ws2811_SetBrightness(_channel, brightness);
    ws2811_SetStripType(_channel, strip_type);

    // Initialize the controller
    ws2811_SetFreq(_leds, freq_hz);
    ws2811_SetDmaNum(_leds, dma);
  }

  void free()
  {
    if (_leds != null) {
      deleteWS2811(_leds);
    }
  }

  /// Initialize library, must be called once before other functions are called.
  void begin()
  {
    var resp = ws2811_Init(_leds);
    if (resp != WS2811_SUCCESS) {
      var message = Utf8.fromUtf8(ws2811_GetResponse_str(resp));
      throw Exception('ws2811_init failed with code $resp ($message)');
    }
  }

  /// Update the display with the data from the LED buffer.
  void show() {
    var resp = ws2811_Render(_leds);
    if (resp != WS2811_SUCCESS) {
      var message = Utf8.fromUtf8(ws2811_GetResponse_str(resp));
      throw Exception('ws2811_Render failed with code $resp ($message)');
    }
  }

  /// Get number of pixels (LEDs).
  int numPixels()
  {
    return ws2811_GetCount(_channel);
  }

  /// Set [color] to the pixel at [pos].
  void setPixelColor(int pos, int color)
  {
    var resp = ws2811_SetLed(_channel, pos, color);
    if (resp != 0) {
      throw RangeError('ws2811_SetLed: pos=$pos should be in range (0-${numPixels()}).');
    }
  }

  /// Get color of pixel at [pos].
  int getPixelColor(int pos)
  {
    return ws2811_GetLed(_channel, pos);
  }

  /// Set LED at position [pos] to the provided [red], [green], and [blue] color.
  ///
	/// Each color component should be a value from 0 to 255 (where 0 is the
	/// lowest intensity and 255 is the highest intensity).
  void setPixelColorRGB(int pos, int red, int green, int blue, [white = 0]) {
    setPixelColor(pos, Color(red, green, blue, white));
  }

  /// Scale each LED in the buffer by the provided brightness.
  ///
  /// A brightness of 0 is the darkest and 255 is the brightest.
  void setBrightness(int brightness) {
    ws2811_SetBrightness(_channel, brightness);
  }

  /// Get the brightness value of each LED in the buffer.
  ///
  /// A brightness of 0 is the darkest and 255 is the brightest.
  int getBrightness() {
    return ws2811_GetBrightness(_channel);
  }
}
