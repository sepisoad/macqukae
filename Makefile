DEBUG ?= 1
USE_CODEC_WAVE ?= 1
CC ?= gcc
DFLAGS ?=
CFLAGS ?= -Wall -MMD -std=gnu11

ifeq ($(DEBUG),1)
    DFLAGS += -DDEBUG
    CFLAGS += -O0 -g
else
    DFLAGS += -DNDEBUG
    CFLAGS += -O2
endif

CFLAGS += -DUSE_SDL2 -DGL_SILENCE_DEPRECATION=1 $(DFLAGS)
SDL_CFLAGS := $(shell sdl2-config --cflags)
SDL_LIBS := $(shell sdl2-config --libs)
CFLAGS += -DUSE_CODEC_WAVE $(SDL_CFLAGS)
COMMON_LIBS = -Wl,-framework,OpenGL -Wl,-framework,Cocoa -Wl,-framework,IOKit
LIBS = $(COMMON_LIBS) $(NET_LIBS) $(SDL_LIBS)

# Output directory
BUILD_DIR := _build
OBJ_DIR := $(BUILD_DIR)/obj
BIN_DIR := $(BUILD_DIR)/bin

# Locate all source files in current directory
SRCS := $(wildcard *.c) $(wildcard *.m)

# Object files
MUSIC_OBJS = bgmusic.o snd_codec.o snd_wave.o

COMOBJ_SND = snd_dma.o snd_mix.o snd_mem.o $(MUSIC_OBJS)
SYSOBJ_SND = snd_sdl.o
SYSOBJ_INPUT = in_sdl.o
SYSOBJ_GL_VID = gl_vidsdl.o
SYSOBJ_NET = net_bsd.o net_udp.o
SYSOBJ_SYS = pl_osx.o sys_sdl_unix.o
SYSOBJ_MAIN = main_sdl.o

GLOBJS = gl_refrag.o gl_rlight.o gl_rmain.o gl_fog.o gl_rmisc.o r_part.o \
         r_world.o gl_screen.o gl_sky.o gl_warp.o $(SYSOBJ_GL_VID) \
         gl_draw.o image.o gl_texmgr.o gl_mesh.o r_sprite.o r_alias.o \
         r_brush.o gl_model.o

OBJS = strlcat.o strlcpy.o $(GLOBJS) $(SYSOBJ_INPUT) $(COMOBJ_SND) \
       $(SYSOBJ_SND) $(SYSOBJ_NET) net_dgrm.o net_loop.o \
       net_main.o chase.o cl_demo.o cl_input.o cl_main.o cl_parse.o \
       cl_tent.o console.o keys.o menu.o sbar.o view.o wad.o cmd.o \
       common.o miniz.o crc.o cvar.o cfgfile.o host.o host_cmd.o \
       mathlib.o pr_cmds.o pr_edict.o pr_exec.o sv_main.o sv_move.o \
       sv_phys.o sv_user.o world.o zone.o $(SYSOBJ_SYS) $(SYSOBJ_MAIN)

# Prefix object files with output directory
OBJ_FILES := $(patsubst %.o,$(OBJ_DIR)/%.o,$(OBJS))

# Targets
.PHONY: all clean

all: $(BIN_DIR)/macquake

$(BIN_DIR)/macquake: $(OBJ_FILES) | $(BIN_DIR)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	$(CC) -c $< -o $@ $(CFLAGS)

$(OBJ_DIR)/%.o: %.m | $(OBJ_DIR)
	clang -c $< -o $@ $(CFLAGS)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean:
	rm -rf $(BUILD_DIR)
