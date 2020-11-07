import 'package:rpi_ws281x/rpi_ws281x.dart';
import 'dart:io';

// LED strip configuration:
var LED_COUNT      = 16;      // Number of LED pixels.
var LED_PIN        = 18;      // GPIO pin connected to the pixels (18 uses PWM!).
//var LED_PIN        = 10;      // GPIO pin connected to the pixels (10 uses SPI /dev/spidev0.0).
var LED_FREQ_HZ    = 800000;  // LED signal frequency in hertz (usually 800khz)
var LED_DMA        = 10;      // DMA channel to use for generating signal (try 10)
var LED_BRIGHTNESS = 255;     // Set to 0 for darkest and 255 for brightest
var LED_INVERT     = false;   // True to invert the signal (when using NPN transistor level shift)
var LED_CHANNEL    = 0;       // set to '1' for GPIOs 13, 19, 41, 45 or 53

// Define functions which animate LEDs in various ways.
void colorWipe(WS281x strip, int color, [int wait_ms=50]) {
  // Wipe color across display a pixel at a time.
  for (var i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, color);
    strip.show();
    sleep(Duration(milliseconds: wait_ms));
  }
}

void main() {
  // Relative path to the shared library.
  var ws2811LibPath = '../lib/c_src/libws2811wrap.so';
  // Create WS281x object with appropriate configuration.
  var strip = WS281x(ws2811LibPath, LED_COUNT, LED_PIN, freq_hz: LED_FREQ_HZ, dma: LED_DMA, invert: LED_INVERT,
                     brightness: LED_BRIGHTNESS, channel: LED_CHANNEL);
  // Intialize the library (must be called once before other functions).
  strip.begin();

  print('Color wipe animations.');
  colorWipe(strip, Color(255, 0, 0)); // Red wipe
  colorWipe(strip, Color(0, 255, 0)); // Blue wipe
  colorWipe(strip, Color(0, 0, 255)); // Green wipe
  colorWipe(strip, Color(0, 0, 0), 10);

  strip.free();
}
