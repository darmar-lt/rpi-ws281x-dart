#ifndef __WS281x_wrap_H__
#define __WS281x_wrap_H__

#include "stdint.h"
#include "rpi_ws281x/ws2811.h"

#ifdef __cplusplus
extern "C" {
#endif
    
ws2811_t* new_ws2811_t();
void delete_ws2811_t(ws2811_t* ws);
int ws2811_init_strip(ws2811_t *ws);
int ws2811_render_strip(ws2811_t *ws);
void ws2811_set_freq(ws2811_t* ws, uint32_t freq_hz);
void ws2811_set_dmanum(ws2811_t* ws, int dma);
ws2811_channel_t* ws2811_get_channel(ws2811_t* ws, int channelnum);

void ws2811_set_count(ws2811_channel_t* channel, int count);
int ws2811_get_count(ws2811_channel_t* channel);
void ws2811_set_gpionum(ws2811_channel_t* channel, int gpionum);
void ws2811_set_invert(ws2811_channel_t* channel, int invert);
void ws2811_set_brightness(ws2811_channel_t* channel, int brightness);
int ws2811_get_brightness(ws2811_channel_t* channel);
void ws2811_set_strip_type(ws2811_channel_t* channel, int strip_type);
int ws2811_set_led(ws2811_channel_t* channel, int lednum, uint32_t color);
uint32_t ws2811_get_led(ws2811_channel_t* channel, int lednum);

const char* ws2811_get_response_str(int resp);

    
#ifdef __cplusplus
}
#endif

#endif /* __WS281x_wrap_H__ */
