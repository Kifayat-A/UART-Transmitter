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
async def test_parity(dut):
    await reset(dut)
    dut.parity_type.value = 1
    dut.data_in.value = 0x0
    await Timer(1,"ns")
    dut.data_in.value = 0xAB
    await Timer(1,"ns")
    dut.data_in.value = 0x0
    await Timer(1,"ns")
    dut.data_in.value = 0xAB
    await Timer(1000,"ns")