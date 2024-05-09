const Console = @import("Console.zig");

pub fn main() !void {
    const wellcome = "Wellcome to ShubungOS!";
    Console.clearScreen();
    try Console.writeStringAtPos(Console.getColor(.white, .black), wellcome, 0, 0);
}
