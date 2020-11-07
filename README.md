rpi-ws281x-dart
===============

It is Dart language binding for rpi_ws281x library.
The rpi_ws281x library enables controlling WS281X LEDs.
Using Dart binding, you can control your LEDs directly
from Dart code. More info about rpi_ws281x:

    https://github.com/jgarff/rpi_ws281x

### Build:

- Install Scons (on raspbian, `apt-get install scons`).
- Go to <rpi-w281x-dart>/lib/c_src
- Type `scons`

`scons` will create 'libws2811wrap.so' in the current directory.

### Running:

- Go to <rpi-w281x-dart>/test directory.
- Type `sudo dart rpi_ws281x_test.dart` (default uses PWM channel 0,
  here is assumed that 'dart' is in your PATH).
- That's it. You should see lighting LEDs.
