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

OBJDIR = obj_dir
VPROJ = $(OBJDIR)/V$(PROJ)

.PHONY: all
all: $(PROJ)

$(VPROJ).cpp: $(PROJ).v
	verilator -Wall -cc $(PROJ).v

$(VPROJ)__ALL.a: $(VPROJ).cpp
	make -C obj_dir -f V$(PROJ).mk

# Build a simulation
$(PROJ): $(PROJ).cpp $(VPROJ)__ALL.a
	@echo "Building a Verilator-based simulation of "$(PROJ)
	g++ -I/usr/local/share/verilator/include  -I $(OBJDIR)     \
		/usr/local/share/verilator/include/verilated.cpp \
		$(PROJ).cpp $(VPROJ)__ALL.a      \
		-o $(PROJ)

%.blif: %.v
	yosys -p 'synth_ice40 -top $(PROJ) -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^


# .PHONY: yosys nextpnr icepack
# yosys: thruwire.json
# thruwire.json:	thruwire.v
# 	yosys -p 'synth_ice40 -json thruwire.json' thruwire.v

#
# This is the appropriate build script for an ICO board
# Your build script will vary depending upon your board
#

# nextpnr: thruwire.asc
# thruwire.asc: thruwire.json hx8kboard.pcf
# 	nextpnr-ice40 --hx8k --package ct256 --pcf demo.pcf --json thruwire.json

icepack: $(PROJ).bin
$(PROJ).bin: $(PROJ).asc
	icepack $(PROJ).asc $(PROJ).bin
	
.PHONY: clean
clean:
	rm -rf obj_dir/ $(PROJ)



