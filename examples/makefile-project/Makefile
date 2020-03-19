################################################################################
##
## Filename: 	Makefile
##
## Project:	Verilog Tutorial Example file
##
## Purpose:	Builds the thruwire Verilator simulationo
##
## Targets:
##
##	The (default) or all target will build the thruwire verilator
##	simulation.
##
##	clean	Removes all build products
##
## Creator:	Dan Gisselquist, Ph.D.
##		Gisselquist Technology, LLC
##
################################################################################
##
## Written and distributed by Gisselquist Technology, LLC
##
## This program is hereby granted to the public domain.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
## FITNESS FOR A PARTICULAR PURPOSE.
##
################################################################################
##
##
PROJ = thruwire
PIN_DEF = hx8kboard.pcf
DEVICE = hx8k

SIM_OBJ_DIR = obj_dir

SIM_DRIVER_SRC = $(PROJ).cpp
SIM_DRIVER_EXC = $(SIM_OBJ_DIR)/$(PROJ)-sim
VSIM = $(SIM_OBJ_DIR)/V$(PROJ)
# VSIM_ALL_A
# VPROJ.mk

BINDIR = build
BLIF = $(BINDIR)/$(PROJ).blif
ASC = $(BINDIR)/$(PROJ).asc
BIN = $(BINDIR)/$(PROJ).bin

all: $(SIM_DRIVER_EXC)
sim: $(SIM_DRIVER_EXC)

$(VSIM).cpp: $(PROJ).v
	verilator -Wall -cc $(PROJ).v

$(VSIM)__ALL.a: $(VSIM).cpp
	make -C obj_dir -f V$(PROJ).mk

# Build a simulation
$(SIM_DRIVER_EXC): $(SIM_DRIVER_SRC) $(VSIM)__ALL.a
	@echo "Building a Verilator-based simulation of "$(SIM_DRIVER_EXC)
	g++ -I/usr/local/share/verilator/include  -I $(SIM_OBJ_DIR)     \
		/usr/local/share/verilator/include/verilated.cpp \
		$(SIM_DRIVER_SRC) $(VSIM)__ALL.a      \
		-o $(SIM_DRIVER_EXC)

# yosys: thruwire.json
# thruwire.json:	thruwire.v
# 	yosys -p 'synth_ice40 -json thruwire.json' thruwire.v

# nextpnr: thruwire.asc
# thruwire.asc: thruwire.json hx8kboard.pcf
# 	nextpnr-ice40 --hx8k --package ct256 --pcf demo.pcf --json thruwire.json

$(BLIF): $(PROJ).v
	mkdir -p $(BINDIR)
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

$(ASC): $(PIN_DEF) $(BLIF)
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^


bin: $(BIN)
icepack: $(BIN)
$(BIN): $(ASC)
	icepack $(ASC) $(BIN)
	
.PHONY: clean
clean:
	rm -rf $(SIM_OBJ_DIR)/ $(BINDIR)/

