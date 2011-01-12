/*
 * wm8994.h  --  WM8994 Soc Audio driver
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

void voodoo_hook_fmradio_headset(void);
unsigned int voodoo_hook_wm8994_write(struct snd_soc_codec *codec, unsigned int reg, unsigned int value);
void voodoo_hook_wm8994_pcm_probe(struct snd_soc_codec *codec);
void update_hpvol(void);
void update_fm_radio_headset_restore_bass(bool with_mute);
