/*
 * voodoo_sound.c  --  WM8994 ALSA Soc Audio driver related
 *
 *  Copyright (C) 2010 François SIMOND / twitter & XDA-developers @supercurio
 *
 *  This program is free software; you can redistribute  it and/or modify it
 *  under  the terms of  the GNU General  Public License as published by the
 *  Free Software Foundation;  either version 2 of the  License, or (at your
 *  option) any later version.
 *
 */

#include <sound/soc.h>
#include <sound/soc-dapm.h>
#include <linux/delay.h>
#include <asm/io.h>
#include <asm/gpio.h>
#include <plat/gpio-cfg.h>
#include <plat/map-base.h>
#include <mach/regs-clock.h>
#include <mach/gpio.h>
#include <linux/miscdevice.h>
#include "wm8994.h"
#include "wm8994_voodoo.h"

#define SUBJECT "wm8994_voodoo.c"
#define VOODOO_SOUND_VERSION 1


#ifdef CONFIG_SND_VOODOO_HP_LEVEL_CONTROL
unsigned short hplvol = CONFIG_SND_VOODOO_HP_LEVEL;
unsigned short hprvol = CONFIG_SND_VOODOO_HP_LEVEL;
bool hpvol_force = true;
#endif

bool fm_radio_headset_restore_bass = true;

// keep here a pointer to the codec structure
struct snd_soc_codec *codec_;


#ifdef CONFIG_SND_VOODOO_HP_LEVEL_CONTROL
void update_hpvol()
{
	unsigned short val;

	hpvol_force = false;
	// hard limit to 62 because 63 introduces distortions
	if (hplvol > 62)
		hplvol = 62;
	if (hprvol > 62)
		hprvol = 62;

	// we don't need the Volume Update flag when sending the first volume
	val = (WM8994_HPOUT1L_MUTE_N | hplvol);
	val |= WM8994_HPOUT1L_ZC;
	wm8994_write(codec_, WM8994_LEFT_OUTPUT_VOLUME, val);

	// this time we write the right volume plus the Volume Update flag. This way, both
	// volume are set at the same time
	val = (WM8994_HPOUT1_VU | WM8994_HPOUT1R_MUTE_N | hprvol);
	val |= WM8994_HPOUT1L_ZC;
	wm8994_write(codec_, WM8994_RIGHT_OUTPUT_VOLUME, val);

	hpvol_force = true;
}
#endif

#ifdef CONFIG_SND_VOODOO_FM
void update_fm_radio_headset_restore_bass(bool with_mute)
{
	if (with_mute)
	{
		wm8994_write(codec_, WM8994_AIF2_DAC_FILTERS_1, 0x236);
		msleep(180);
	}

	if (fm_radio_headset_restore_bass)
	{
		// disable Sidetone high-pass filter designed for voice and not FM radio
		// 0x621 0x0000 SMbus_16inx_16dat     Write  0x34      * Sidetone(621H):          0000  ST_HPF_CUT=000, ST_HPF=0, ST2_SEL=0, ST1_SEL=0
		wm8994_write(codec_, WM8994_SIDETONE, 0x0000);
		// disable 4FS ultrasonic mode and restore the hi-fi <4Hz hi pass filter
		// 0x510 0x1800 SMbus_16inx_16dat     Write  0x34      * AIF2 ADC Filters(510H):  1800  AIF2ADC_4FS=0, AIF2ADC_HPF_CUT=00, AIF2ADCL_HPF=1, AIF2ADCR_HPF=1
		wm8994_write(codec_, WM8994_AIF2_ADC_FILTERS, 0x1800);
	}
	else
	{
		// default settings in GT-I9000 Froyo XXJPX kernel sources
		wm8994_write(codec_, WM8994_SIDETONE, 0x01c0);
		wm8994_write(codec_, WM8994_AIF2_ADC_FILTERS, 0xF800);
	}

	// un-mute
	if (with_mute)
		wm8994_write(codec_, WM8994_AIF2_DAC_FILTERS_1, 0x036);
}
#endif


/*
 *
 * Declaring the controling misc devices
 *
 */
#ifdef CONFIG_SND_VOODOO_HP_LEVEL_CONTROL
static ssize_t headphone_amplifier_level_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	// output median of left and right headphone amplifier volumes
	return sprintf(buf,"%u\n", (hplvol + hprvol) / 2 );
}

static ssize_t headphone_amplifier_level_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t size)
{
	unsigned short vol;
	if (sscanf(buf, "%hu", &vol) == 1)
	{
		// left and right are set to the same volumes
		hplvol = hprvol = vol;
		update_hpvol();
	}
	return size;
}
#endif

#ifdef CONFIG_SND_VOODOO_FM
static ssize_t fm_radio_headset_restore_bass_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	return sprintf(buf,"%u\n",(fm_radio_headset_restore_bass ? 1 : 0));
}

static ssize_t fm_radio_headset_restore_bass_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t size)
{
	unsigned short state;
	if (sscanf(buf, "%hu", &state) == 1)
	{
		if (state == 0)
			fm_radio_headset_restore_bass = false;
		else
			fm_radio_headset_restore_bass = true;

		update_fm_radio_headset_restore_bass(true);
	}
	return size;
}
#endif

#ifdef CONFIG_SND_VOODOO_DEBUG
static ssize_t show_wm8994_register_dump(struct device *dev, struct device_attribute *attr, char *buf)
{
	// modified version of wm8994_register_dump from wm8994_aries.c
	int wm8994_register;

	for(wm8994_register = 0; wm8994_register <= 0x6; wm8994_register++)
		sprintf(buf, "0x%X 0x%X\n", wm8994_register, wm8994_read(codec_, wm8994_register));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x15, wm8994_read(codec_, 0x15));
	for(wm8994_register = 0x18; wm8994_register <= 0x3C; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x4C, wm8994_read(codec_, 0x4C));
	for(wm8994_register = 0x51; wm8994_register <= 0x5C; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x60, wm8994_read(codec_, 0x60));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x101, wm8994_read(codec_, 0x101));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x110, wm8994_read(codec_, 0x110));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x111, wm8994_read(codec_, 0x111));
	for(wm8994_register = 0x200; wm8994_register <= 0x212; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x220; wm8994_register <= 0x224; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x240; wm8994_register <= 0x244; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x300; wm8994_register <= 0x317; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x400; wm8994_register <= 0x411; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x420; wm8994_register <= 0x423; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x440; wm8994_register <= 0x444; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x450; wm8994_register <= 0x454; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x480; wm8994_register <= 0x493; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x4A0; wm8994_register <= 0x4B3; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x500; wm8994_register <= 0x503; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x510, wm8994_read(codec_, 0x510));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x520, wm8994_read(codec_, 0x520));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x521, wm8994_read(codec_, 0x521));
	for(wm8994_register = 0x540; wm8994_register <= 0x544; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x580; wm8994_register <= 0x593; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	for(wm8994_register = 0x600; wm8994_register <= 0x614; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x620, wm8994_read(codec_, 0x620));
	sprintf(buf, "%s0x%X 0x%X\n", buf, 0x621, wm8994_read(codec_, 0x621));
	for(wm8994_register = 0x700; wm8994_register <= 0x70A; wm8994_register++)
		sprintf(buf, "%s0x%X 0x%X\n", buf, wm8994_register, wm8994_read(codec_, wm8994_register));

	return sprintf(buf, "%s", buf);
}


static ssize_t store_wm8994_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t size)
{
	short unsigned int reg = 0;
	short unsigned int val = 0;
	int unsigned bytes_read = 0;

	while (sscanf(buf, "%hx %hx%n", &reg, &val, &bytes_read) == 2)
	{
		buf += bytes_read;
		wm8994_write(codec_, reg, val);
	}
	return size;
}
#endif


static ssize_t voodoo_sound_version(struct device *dev, struct device_attribute *attr, char *buf) {
	return sprintf(buf, "%u\n", VOODOO_SOUND_VERSION);
}

#ifdef CONFIG_SND_VOODOO_HP_LEVEL_CONTROL
static DEVICE_ATTR(headphone_amplifier_level, S_IRUGO | S_IWUGO , headphone_amplifier_level_show, headphone_amplifier_level_store);
#endif
#ifdef CONFIG_SND_VOODOO_FM
static DEVICE_ATTR(fm_radio_headset_restore_bass, S_IRUGO | S_IWUGO , fm_radio_headset_restore_bass_show, fm_radio_headset_restore_bass_store);
#endif
#ifdef CONFIG_SND_VOODOO_DEBUG
static DEVICE_ATTR(wm8994_register_dump, S_IRUGO , show_wm8994_register_dump, NULL);
static DEVICE_ATTR(wm8994_write, S_IWUSR , NULL, store_wm8994_write);
#endif
static DEVICE_ATTR(version, S_IRUGO , voodoo_sound_version, NULL);

static struct attribute *voodoo_sound_attributes[] = {
#ifdef CONFIG_SND_VOODOO_HP_LEVEL_CONTROL
		&dev_attr_headphone_amplifier_level.attr,
#endif
#ifdef CONFIG_SND_VOODOO_FM
		&dev_attr_fm_radio_headset_restore_bass.attr,
#endif
#ifdef CONFIG_SND_VOODOO_DEBUG
		&dev_attr_wm8994_register_dump.attr,
		&dev_attr_wm8994_write.attr,
#endif
		&dev_attr_version.attr,
		NULL
};

static struct attribute_group voodoo_sound_group = {
		.attrs  = voodoo_sound_attributes,
};

static struct miscdevice voodoo_sound_device = {
		.minor = MISC_DYNAMIC_MINOR,
		.name = "voodoo_sound",
};


/*
 *
 * Driver Hooks
 *
 */

#ifdef CONFIG_SND_VOODOO_FM
void voodoo_hook_fmradio_headset()
{
	if (! fm_radio_headset_restore_bass)
		return;

	printk("Voodoo sound: correct FM radio sound output\n");
	update_fm_radio_headset_restore_bass(false);
}
#endif


unsigned int voodoo_hook_wm8994_write(struct snd_soc_codec *codec, unsigned int reg, unsigned int value)
{
	// modify some registers before those being written to the codec
#ifdef CONFIG_SND_VOODOO_HP_LEVEL_CONTROL
	// sniff headphone amplifier level changes and apply our level instead
	if (hpvol_force)
	{
		if (reg == WM8994_LEFT_OUTPUT_VOLUME)
			value = (WM8994_HPOUT1_VU | WM8994_HPOUT1L_MUTE_N | hplvol);
		if (reg == WM8994_RIGHT_OUTPUT_VOLUME)
			value = (WM8994_HPOUT1_VU | WM8994_HPOUT1R_MUTE_N | hprvol);
	}
#endif

#ifdef CONFIG_SND_VOODOO_DEBUG
	// log every write to dmesg
	DEBUG_LOG_ERR("register= [%X] value= [%X]", reg, value);
#endif
	return value;
}


void voodoo_hook_wm8994_pcm_probe(struct snd_soc_codec *codec)
{
	misc_register(&voodoo_sound_device);
	if (sysfs_create_group(&voodoo_sound_device.this_device->kobj, &voodoo_sound_group) < 0)
	{
		printk("%s sysfs_create_group fail\n", __FUNCTION__);
		pr_err("Failed to create sysfs group for device (%s)!\n", voodoo_sound_device.name);
	}

	// make a copy of the codec pointer
	codec_ = codec;
}
