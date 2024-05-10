const std = @import("std");

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

pub usingnamespace struct {
    row: usize,
    column: usize,
    color: Color,

    const This = @This();

    pub fn init(color: Color, r: usize, c: usize) This {
        return .{ .row = r, .column = c, .color = color };
    }

    pub fn newLine(self: *This) void {
        self.row += 1;
    }

    pub fn writeChar(self: *This, char: u8) !void {
        try writeCharAtPos(self.color, char, self.row, self.column);
        if (self.column + 1 > 80) {
            self.newLine();
        } else {
            self.column += 1;
        }
    }

    pub fn writeString(self: *This, str: []const u8) !void {
        try writeStringAtPos(self.color, str, self.row, self.column);
        if (self.column + str.len > 80) {
            self.column = self.column + str.len - 80;
            self.newLine();
        } else {
            self.column += str.len;
        }
    }

    pub fn setColor(self: *This, color: Color) void {
        self.color = color;
    }

    //pub fn print(self: *This, comptime fmt: []const u8, args: anytype) !void {
    //    const str = std.fmt.comptimePrint(fmt, args);
    //    try self.writeString(str);
    //}
};
