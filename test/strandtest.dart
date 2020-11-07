import 'package:rpi_ws281x/rpi_ws281x.dart';
import 'dart:io';

// LED strip configuration:
var LED_COUNT = 16; // Number of LED pixels.
var LED_PIN = 18; // GPIO pin connected to the pixels (18 uses PWM!).
//var LED_PIN        = 10;      // GPIO pin connected to the pixels (10 uses SPI /dev/spidev0.0).
var LED_FREQ_HZ = 800000; // LED signal frequency in hertz (usually 800khz)
var LED_DMA = 10; // DMA channel to use for generating signal (try 10)
var LED_BRIGHTNESS = 255; // Set to 0 for darkest and 255 for brightest
var LED_INVERT =
    false; // True to invert the signal (when using NPN transistor level shift)
var LED_CHANNEL = 0; // set to '1' for GPIOs 13, 19, 41, 45 or 53

/// Define functions which animate LEDs in various ways.
Future<void> colorWipe(WS281x strip, int color, [int wait_ms = 50]) async {
  // Wipe color across display a pixel at a time.
  for (var i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, color);
    strip.show();
    await Future.delayed(Duration(milliseconds: wait_ms));
  }
}

/// Movie theater light style chaser animation.
Future<void> theaterChase(WS281x strip, int color,
    [int wait_ms = 50, int iterations = 10]) async {
  for (var j = 0; j < iterations; j++) {
    for (var q = 0; q < 3; q++) {
      for (var i = 0; i < (strip.numPixels() - q); i += 3) {
        strip.setPixelColor(i + q, color);
      }
      strip.show();
      await Future.delayed(Duration(milliseconds: wait_ms));
      for (var i = 0; i < (strip.numPixels() - q); i += 3) {
        strip.setPixelColor(i + q, 0);
      }
    }
  }
}

/// Generate rainbow colors across 0-255 positions.
int wheel(int pos) {
  if (pos < 85) {
    return Color(pos * 3, 255 - pos * 3, 0);
  } else if (pos < 170) {
    pos -= 85;
    return Color(255 - pos * 3, 0, pos * 3);
  } else {
    pos -= 170;
    return Color(0, pos * 3, 255 - pos * 3);
  }
}

/// Draw rainbow that fades across all pixels at once.
Future<void> rainbow(WS281x strip, [int wait_ms = 20, iterations = 1]) async {
  for (var j = 0; j < (256 * iterations); j++) {
    for (var i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, wheel((i + j) & 255));
    }
    strip.show();
    await Future.delayed(Duration(milliseconds: wait_ms));
  }
}

/// Draw rainbow that uniformly distributes itself across all pixels.
Future<void> rainbowCycle(strip, [wait_ms = 20, iterations = 5]) async {
  for (var j = 0; j < (256 * iterations); j++) {
    for (var i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, wheel(((i * 256 ~/ strip.numPixels()) + j) & 255));
    }
    strip.show();
    await Future.delayed(Duration(milliseconds: wait_ms));
  }
}

/// Rainbow movie theater light style chaser animation.
Future<void> theaterChaseRainbow(strip, [wait_ms = 50]) async {
  for (var j = 0; j < 256; j++) {
    for (var q = 0; q < 3; q++) {
      for (var i = 0; i < (strip.numPixels() - q); i += 3) {
        strip.setPixelColor(i + q, wheel((i + j) % 255));
      }
      strip.show();
      await Future.delayed(Duration(milliseconds: wait_ms));
      for (var i = 0; i < (strip.numPixels() - q); i += 3) {
        strip.setPixelColor(i + q, 0);
      }
    }
  }
}

Future<void> main() async {
  // Relative path to the shared library.
  var ws2811LibPath = '../lib/c_src/libws2811wrap.so';
  // Create WS281x object with appropriate configuration.
  var strip = WS281x(ws2811LibPath, LED_COUNT, LED_PIN,
      freq_hz: LED_FREQ_HZ,
      dma: LED_DMA,
      invert: LED_INVERT,
      brightness: LED_BRIGHTNESS,
      channel: LED_CHANNEL);
  // Initialize the library (must be called once before other functions).
  strip.begin();

  // Register function which is called when Ctrl+C is pressed.
  ProcessSignal.sigint.watch().listen((signal) {
    // Turn off leds
    for (var i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, 0);
      strip.show();
      sleep(Duration(milliseconds: 10));
    }
    strip.free(); // Delete WS281x object.
    exit(0);
  });

  while (true) {
    print('Color wipe animations.');
    await colorWipe(strip, Color(255, 0, 0)); // Red wipe
    await colorWipe(strip, Color(0, 255, 0)); // Blue wipe
    await colorWipe(strip, Color(0, 0, 255)); // Green wipe
    print('Theater chase animations.');
    await theaterChase(strip, Color(127, 127, 127)); // White theater chase
    await theaterChase(strip, Color(127, 0, 0)); // Red theater chase
    await theaterChase(strip, Color(0, 0, 127)); // Blue theater chase
    print('Rainbow animations.');
    await rainbow(strip);
    await rainbowCycle(strip);
    await theaterChaseRainbow(strip);
  }
}
