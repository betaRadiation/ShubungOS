const main = @import("main.zig");
const Console = @import("Console.zig");

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

const MultiBoot = extern struct {
    magic: i32,
    flags: i32,
    checksum: i32,
};

export var multiboot align(4) linksection(".multiboot") = MultiBoot{
    .magic = MAGIC,
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

export var stack: [16 * 1024]u8 align(16) linksection(".bss") = undefined;

export fn _start() noreturn {
    asm volatile (
        \\ movl %[stk], %esp
        \\ movl %esp, %ebp
        :
        : [stk] "{ecx}" (@intFromPtr(&stack) + @sizeOf(@TypeOf(stack))),
    );

    main.main() catch |e| {
        const panic_color = Console.getColor(.white, .red);
        Console.writeStringAtPos(panic_color, "KERNEL PANIC, FATAL:", 0, 0) catch unreachable;
        Console.writeStringAtPos(panic_color, "ERROR: ", 1, 0) catch unreachable;
        Console.writeStringAtPos(panic_color, @errorName(e), 1, 7) catch unreachable;
    };

    while (true)
        asm volatile ("hlt");
}
