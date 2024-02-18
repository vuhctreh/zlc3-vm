const std = @import("std");
const expect = @import("std").testing.expect;

const REGISTER_ADDR = enum(u16) { R0 = 0, R1 = 1, R2 = 2, R3 = 3, R4 = 4, R5 = 5, R6 = 6, R7 = 7, RPC = 8, RCND = 0, RCNT = 10 };
const EXCF = enum(u16) { FP = 1 << 0, FZ = 1 << 1, FN = 1 << 2 };

const Vm = struct {
    const Self = @This();
    // Memory for the VM -> 16 bits
    // Start from beginning of memory as we are not implementing anything else in our VM.
    mem: [65535]u16 = [_]u16{0} ** 65535,

    // VM has 10 registers.
    registers: [10]u16 = [_]u16{0} ** 10,
    is_running: bool = false,

    // Read and write to memory
    fn read_mem(self: *Self, addr: u16) u16 {
        return self.mem[addr];
    }

    fn write_mem(self: *Self, addr: u16, val: u16) !void {
        self.mem[addr] = val;
    }

    // Read and write to registers.
    fn read_reg(self: *Self, register: REGISTER_ADDR) u16 {
        return self.registers[register];
    }

    fn write_reg(self: *Self, register: REGISTER_ADDR, val: u16) !void {
        self.registers[register] = val;
    }

    // TODO: impl calling instruction with function pointers.
    fn get_opc(instr: u16) u16 {
        return instr >> 12;
    }

    fn update_flag(self: *Self, register: REGISTER_ADDR) !void {
        if (self.registers[register] == EXCF.FP) {
            self.registers[REGISTER_ADDR.RCND] = REGISTER_ADDR.FZ;
        } else if (self.registers[register] >> 15) {
            self.registers[REGISTER_ADDR.RCND] = REGISTER_ADDR.FN;
        } else {
            self.registers[REGISTER_ADDR.RCND] = REGISTER_ADDR.FP;
        }
    }
};

// const test_struct = struct {
//     mem: [65535]u16 = [_]u16{0} ** 65535,
//     const Self = @This();

//     fn read_mem(self: @This(), addr: u16) u16 {
//         return self.mem[addr];
//     }

//     fn write_mem(self: *Self, addr: u16, val: u16) !void {
//         self.mem[addr] = val;
//     }
// };

pub fn main() !void {
    var vm: Vm = Vm{};

    try vm.write_mem(15, 10);

    std.debug.print("Hello world!\n{}\n", .{vm.read_mem(15)});
}
