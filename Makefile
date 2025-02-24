DEBUG=0
USE_CODEC_WAVE=1
CC ?= gcc
DFLAGS ?=
CFLAGS ?= -Wall -MMD
CFLAGS += -std=gnu11
ifneq ($(DEBUG),0)
DFLAGS += -DDEBUG
CFLAGS += -O0 -g
else
DFLAGS += -DNDEBUG
CFLAGS += -O2
endif

CFLAGS += -DUSE_SDL2
CFLAGS += -DGL_SILENCE_DEPRECATION=1
SDL_CFLAGS := $(shell sdl2-config --cflags)
SDL_LIBS := $(shell sdl2-config --libs)
CFLAGS+= -DUSE_CODEC_WAVE $(SDL_CFLAGS)
COMMON_LIBS = -Wl,-framework,OpenGL -Wl,-framework,Cocoa -Wl,-framework,IOKit
LIBS = $(COMMON_LIBS) $(NET_LIBS) $(SDL_LIBS)

# ---------------------------
# objects
# ---------------------------

MUSIC_OBJS= bgmusic.o \
	snd_codec.o \
	snd_flac.o \
	snd_wave.o \
	snd_vorbis.o \
	snd_opus.o \
	snd_mp3tag.o \
	snd_mikmod.o \
	snd_modplug.o \
	snd_xmp.o \
	snd_umx.o
COMOBJ_SND = snd_dma.o snd_mix.o snd_mem.o $(MUSIC_OBJS)
SYSOBJ_SND = snd_sdl.o
SYSOBJ_CDA = cd_sdl.o
SYSOBJ_INPUT = in_sdl.o
SYSOBJ_GL_VID= gl_vidsdl.o
SYSOBJ_NET = net_bsd.o net_udp.o
SYSOBJ_SYS = pl_osx.o sys_sdl_unix.o
SYSOBJ_MAIN= main_sdl.o

GLOBJS = \
	gl_refrag.o \
	gl_rlight.o \
	gl_rmain.o \
	gl_fog.o \
	gl_rmisc.o \
	r_part.o \
	r_world.o \
	gl_screen.o \
	gl_sky.o \
	gl_warp.o \
	$(SYSOBJ_GL_VID) \
	gl_draw.o \
	image.o \
	gl_texmgr.o \
	gl_mesh.o \
	r_sprite.o \
	r_alias.o \
	r_brush.o \
	gl_model.o

OBJS = strlcat.o \
	strlcpy.o \
	$(GLOBJS) \
	$(SYSOBJ_INPUT) \
	$(COMOBJ_SND) \
	$(SYSOBJ_SND) \
	$(SYSOBJ_CDA) \
	$(SYSOBJ_NET) \
	net_dgrm.o \
	net_loop.o \
	net_main.o \
	chase.o \
	cl_demo.o \
	cl_input.o \
	cl_main.o \
	cl_parse.o \
	cl_tent.o \
	console.o \
	keys.o \
	menu.o \
	sbar.o \
	view.o \
	wad.o \
	cmd.o \
	common.o \
	miniz.o \
	crc.o \
	cvar.o \
	cfgfile.o \
	host.o \
	host_cmd.o \
	mathlib.o \
	pr_cmds.o \
	pr_edict.o \
	pr_exec.o \
	sv_main.o \
	sv_move.o \
	sv_phys.o \
	sv_user.o \
	world.o \
	zone.o \
	$(SYSOBJ_SYS) \
	$(SYSOBJ_MAIN)

# ------------------------
# build rules for MacOS
# ------------------------

.PHONY:	clean macquake
all: macquake
macquake: $(OBJS)
	$(CC) -o macquake $(OBJS) $(CFLAGS) $(LIBS)
clean:
	rm -f *.o
	rm -f *.d
	rm -f macquake
