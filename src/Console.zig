pub const buffer: [*]volatile u16 = @ptrFromInt(0xB8000);
pub const buffer_rows = 80;
pub const buffer_columns = 25;
pub const VgaColors = enum(u4) {
    black = 0,
    blue = 1,
    green = 2,
    cyan = 3,
    red = 4,
    magenta = 5,
    brown = 6,
    light_grey = 7,
    dark_grey = 8,
    light_blue = 9,
    light_green = 10,
    light_cyan = 11,
    light_red = 12,
    light_magenta = 13,
    light_brown = 14,
    white = 15,
};

const Console_error = error{
    indexOutOfBounds,
};

const This = @This();

pub const Color = u8;

pub fn clearScreen() void {
    var i: usize = 0;
    while (i < buffer_rows * buffer_columns) : (i += 1)
        buffer[i] = @as(u16, getColor(.white, .black)) << 8 | ' ';
}

pub fn getColor(fgColor: VgaColors, bgColor: VgaColors) u8 {
    return @as(u8, @intFromEnum(fgColor)) | @as(u8, @intFromEnum(bgColor)) << 4;
}

pub fn writeCharAtPos(color: Color, char: u8, r: usize, c: usize) !void {
    const index = r * buffer_rows + c;
    if (index > 2000) return Console_error.indexOutOfBounds;
    buffer[index] = @as(u16, color) << 8 | @as(u16, char);
}

pub fn writeStringAtPos(color: Color, str: []const u8, r: usize, c: usize) !void {
    const index = r * buffer_rows + c;
    for (0..str.len) |i| {
        if (index + i > 2000) return Console_error.indexOutOfBounds;
        buffer[index + i] = @as(u16, color) << 8 | @as(u16, str[i]);
    }
}
