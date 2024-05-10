const Console = @import("Console.zig");

pub fn main() !void {
    //const wellcome = "Wellcome to ShubungOS!";
    //Console.clearScreen();
    //try Console.writeStringAtPos(Console.getColor(.white, .black), wellcome, 0, 0);
    Console.clearScreen();
    var term = Console.init(Console.getColor(.white, .black), 0, 0);
    try term.writeChar('H');
    try term.writeString("ello, World!");
    var i: i32 = 0;
    while (i < 200) : (i += 1) {
        try term.writeString("Hello, World!");
    }
}
