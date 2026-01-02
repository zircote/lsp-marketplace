const std = @import("std");
const testing = std.testing;

/// User represents a user in the system
pub const User = struct {
    name: []const u8,
    email: []const u8,
    age: u32,

    /// Returns a greeting message for the user
    pub fn greet(self: User, allocator: std.mem.Allocator) ![]u8 {
        return std.fmt.allocPrint(allocator, "Hello, {s}!", .{self.name});
    }

    /// Checks if the user is an adult (18+)
    pub fn isAdult(self: User) bool {
        return self.age >= 18;
    }
};

/// UserService manages users
pub const UserService = struct {
    users: std.ArrayList(User),
    allocator: std.mem.Allocator,

    /// Creates a new UserService
    pub fn init(allocator: std.mem.Allocator) UserService {
        return UserService{
            .users = std.ArrayList(User).init(allocator),
            .allocator = allocator,
        };
    }

    /// Frees resources
    pub fn deinit(self: *UserService) void {
        self.users.deinit();
    }

    /// Adds a user to the service
    pub fn addUser(self: *UserService, user: User) !void {
        try self.users.append(user);
    }

    /// Finds a user by email
    pub fn findByEmail(self: UserService, email: []const u8) ?User {
        for (self.users.items) |user| {
            if (std.mem.eql(u8, user.email, email)) {
                return user;
            }
        }
        return null;
    }

    /// Returns the number of users
    pub fn count(self: UserService) usize {
        return self.users.items.len;
    }
};

/// Calculates the average of a slice of numbers
pub fn calculateAverage(numbers: []const f64) !f64 {
    if (numbers.len == 0) {
        return error.EmptySlice;
    }

    var sum: f64 = 0;
    for (numbers) |n| {
        sum += n;
    }
    return sum / @as(f64, @floatFromInt(numbers.len));
}

/// Fibonacci sequence generator
pub fn fibonacci(n: u32) u64 {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// TODO: Add more test cases
// FIXME: Handle edge cases for large numbers
// TEST: This is a test comment added to demonstrate hook output

test "User.greet returns correct greeting" {
    const allocator = testing.allocator;
    const user = User{
        .name = "Alice",
        .email = "alice@example.com",
        .age = 25,
    };

    const greeting = try user.greet(allocator);
    defer allocator.free(greeting);

    try testing.expectEqualStrings("Hello, Alice!", greeting);
}

test "User.isAdult returns correct value" {
    const adult = User{ .name = "Alice", .email = "alice@example.com", .age = 25 };
    const minor = User{ .name = "Bob", .email = "bob@example.com", .age = 15 };
    const exact = User{ .name = "Charlie", .email = "charlie@example.com", .age = 18 };

    try testing.expect(adult.isAdult());
    try testing.expect(!minor.isAdult());
    try testing.expect(exact.isAdult());
}

test "UserService operations" {
    const allocator = testing.allocator;
    var service = UserService.init(allocator);
    defer service.deinit();

    const user = User{
        .name = "Bob",
        .email = "bob@example.com",
        .age = 30,
    };

    try service.addUser(user);
    try testing.expectEqual(@as(usize, 1), service.count());

    const found = service.findByEmail("bob@example.com");
    try testing.expect(found != null);
    try testing.expectEqualStrings("Bob", found.?.name);

    const not_found = service.findByEmail("notfound@example.com");
    try testing.expect(not_found == null);
}

test "calculateAverage with positive numbers" {
    const numbers = [_]f64{ 1, 2, 3, 4, 5 };
    const avg = try calculateAverage(&numbers);
    try testing.expectEqual(@as(f64, 3), avg);
}

test "calculateAverage with empty slice returns error" {
    const numbers = [_]f64{};
    try testing.expectError(error.EmptySlice, calculateAverage(&numbers));
}

test "calculateAverage with single number" {
    const numbers = [_]f64{42};
    const avg = try calculateAverage(&numbers);
    try testing.expectEqual(@as(f64, 42), avg);
}

test "fibonacci sequence" {
    try testing.expectEqual(@as(u64, 0), fibonacci(0));
    try testing.expectEqual(@as(u64, 1), fibonacci(1));
    try testing.expectEqual(@as(u64, 1), fibonacci(2));
    try testing.expectEqual(@as(u64, 2), fibonacci(3));
    try testing.expectEqual(@as(u64, 3), fibonacci(4));
    try testing.expectEqual(@as(u64, 5), fibonacci(5));
    try testing.expectEqual(@as(u64, 8), fibonacci(6));
}
