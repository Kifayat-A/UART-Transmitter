import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
from cocotb.regression import TestFactory

async def reset(dut):
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    cocotb.log.info("Reset completed.")

@cocotb.test()
async def test_fifo_sync(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())
    await reset(dut)

    dut.data_in.value = 0x6

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    dut.wr_en.value = 1 
    await RisingEdge(dut.clk)
    dut.wr_en.value = 0

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    dut.data_in.value = 0x4
    dut.wr_en.value = 1 
    await RisingEdge(dut.clk)
    dut.wr_en.value = 0

    await RisingEdge(dut.clk)
    dut.rd_en.value = 1
    await RisingEdge(dut.clk)
    dut.rd_en.value = 0
    await RisingEdge(dut.clk)
    dut.rd_en.value = 1
    await RisingEdge(dut.clk)
    dut.rd_en.value = 0

    dut.wr_en.value = 1
    dut.data_in.value = 0xF
    await RisingEdge(dut.clk)
    dut.wr_en.value = 0
    await Timer(100,"ns")