
#include "ws281x_wrap.h"
#include <stdlib.h>

ws2811_t* new_ws2811_t() {
    ws2811_t* ws = malloc(sizeof(*ws));
    return ws;
}

void delete_ws2811_t(ws2811_t* ws) 
{
    ws2811_fini(ws);
    free(ws);
}

int ws2811_init_strip(ws2811_t *ws)
{
    ws2811_return_t resp = ws2811_init(ws);
    return (int) resp;
}

int ws2811_render_strip(ws2811_t *ws)
{
    ws2811_return_t resp = ws2811_render(ws); 
    return (int) resp;
}

void ws2811_set_freq(ws2811_t* ws, uint32_t freq_hz) 
{
    ws->freq = freq_hz;
}

void ws2811_set_dmanum(ws2811_t* ws, int dma) 
{
    ws->dmanum = dma;
}

ws2811_channel_t* ws2811_get_channel(ws2811_t* ws, int channelnum) 
{
    return &ws->channel[channelnum];
}

void ws2811_set_count(ws2811_channel_t* channel, int count) 
{
    channel->count = count;
}

int ws2811_get_count(ws2811_channel_t* channel)
{
    return channel->count;
}

void ws2811_set_gpionum(ws2811_channel_t* channel, int gpionum) 
{
    channel->gpionum = gpionum;
}
    
void ws2811_set_invert(ws2811_channel_t* channel, int invert) 
{
    channel->invert = invert;
}

void ws2811_set_brightness(ws2811_channel_t* channel, int brightness) 
{
    channel->brightness = brightness;
}

int ws2811_get_brightness(ws2811_channel_t* channel)
{
    return channel->brightness;
}

void ws2811_set_strip_type(ws2811_channel_t* channel, int strip_type) 
{
    channel->strip_type = strip_type;
}

int ws2811_set_led(ws2811_channel_t* channel, int lednum, uint32_t color)
{
    if (lednum >= channel->count) {
        return -1;
    }
    channel->leds[lednum] = color;
    return 0;
}

uint32_t ws2811_get_led(ws2811_channel_t* channel, int lednum)
{
    if (lednum >= channel->count) {
        return -1;
    }
    return channel->leds[lednum];
}

const char* ws2811_get_response_str(int resp)
{
    ws2811_return_t state = (ws2811_return_t) resp;
    return ws2811_get_return_t_str(state);
}
