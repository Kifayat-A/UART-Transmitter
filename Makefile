VERILOG_SOURCES = src/*.v
TOPLEVEL = piso
MODULE = test_piso
SIM = verilator
EXTRA_ARGS += --trace --trace-fst --no-timing

include $(shell cocotb-config --makefiles)/Makefile.sim

