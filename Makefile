VERILOG_SOURCES = src/uart_tx/*.v
TOPLEVEL = uart_tx
MODULE = test_uarttx
SIM = verilator
EXTRA_ARGS += --trace --trace-fst --no-timing

include $(shell cocotb-config --makefiles)/Makefile.sim

