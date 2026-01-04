import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
from cocotb.regression import TestFactory

async def reset(dut):
    dut.rst_n.value = 1
    await Timer(10,"ns")
    dut.rst_n.value = 0
    await Timer(10,"ns")
    dut.rst_n.value = 1
    cocotb.log.info("Reset completed.")


@cocotb.test()
async def test_bdgen1(dut):
    cocotb.start_soon(Clock(dut.clk, 20, units='ns').start())
    await reset(dut)
    dut.baud_rate.value = 0
    await Timer(5,"ms")

@cocotb.test()
async def test_bdgen2(dut):
    cocotb.start_soon(Clock(dut.clk, 20, units='ns').start())
    await reset(dut)
    dut.baud_rate.value = 1
    await Timer(5,"ms")

@cocotb.test()
async def test_bdgen3(dut):
    cocotb.start_soon(Clock(dut.clk, 20, units='ns').start())
    await reset(dut)
    dut.baud_rate.value = 2
    await Timer(5,"ms")

@cocotb.test()
async def test_bdgen4(dut):
    cocotb.start_soon(Clock(dut.clk, 20, units='ns').start())
    await reset(dut)
    dut.baud_rate.value = 3
    await Timer(5,"ms")