-- Hook test
-- Sample Lua test file for LSP plugin validation.
--
-- This file contains various Lua constructs to test:
-- - LSP operations (hover, go to definition, references)
-- - Hook validation (linting, formatting, testing)

-- User class/table
local User = {}
User.__index = User

--- Creates a new User instance
-- @param name string The user's name
-- @param email string The user's email
-- @param age number The user's age (optional)
-- @return table A new User instance
function User.new(name, email, age)
    local self = setmetatable({}, User)
    self.name = name
    self.email = email
    self.age = age
    return self
end

--- Returns a greeting message for the user
-- @return string Greeting message
function User:greet()
    return "Hello, " .. self.name .. "!"
end

--- Checks if the user is an adult (18+)
-- @return boolean True if adult, false otherwise
function User:is_adult()
    if self.age == nil then
        return false
    end
    return self.age >= 18
end

-- UserService module
local UserService = {}
UserService.__index = UserService

--- Creates a new UserService instance
-- @return table A new UserService instance
function UserService.new()
    local self = setmetatable({}, UserService)
    self.users = {}
    return self
end

--- Adds a user to the service
-- @param user table User instance to add
function UserService:add_user(user)
    table.insert(self.users, user)
end

--- Finds a user by email
-- @param email string Email to search for
-- @return table|nil User instance or nil if not found
function UserService:find_by_email(email)
    for _, user in ipairs(self.users) do
        if user.email == email then
            return user
        end
    end
    return nil
end

--- Gets the count of users
-- @return number Number of users
function UserService:count()
    return #self.users
end

--- Gets all adult users
-- @return table Array of adult users
function UserService:get_adults()
    local adults = {}
    for _, user in ipairs(self.users) do
        if user:is_adult() then
            table.insert(adults, user)
        end
    end
    return adults
end

-- MathUtils module
local MathUtils = {}

--- Calculates the average of a table of numbers
-- @param numbers table Array of numbers
-- @return number|nil Average value or nil if empty
-- @return string|nil Error message if empty
function MathUtils.calculate_average(numbers)
    if #numbers == 0 then
        return nil, "Cannot calculate average of empty table"
    end

    local sum = 0
    for _, num in ipairs(numbers) do
        sum = sum + num
    end

    return sum / #numbers
end

--- Calculates the sum of a table of numbers
-- @param numbers table Array of numbers
-- @return number Sum of all numbers
function MathUtils.sum(numbers)
    local total = 0
    for _, num in ipairs(numbers) do
        total = total + num
    end
    return total
end

-- TODO: Add more test cases
-- FIXME: Handle edge cases for nil values

-- Test functions (simple assertions for demonstration)
local function test_user_greet()
    local user = User.new("Alice", "alice@example.com", 25)
    local greeting = user:greet()
    assert(greeting == "Hello, Alice!", "Greet should return correct message")
    print("✓ test_user_greet passed")
end

local function test_user_is_adult()
    local adult = User.new("Bob", "bob@example.com", 25)
    local minor = User.new("Charlie", "charlie@example.com", 15)
    local no_age = User.new("Dana", "dana@example.com", nil)

    assert(adult:is_adult() == true, "Adult should return true")
    assert(minor:is_adult() == false, "Minor should return false")
    assert(no_age:is_adult() == false, "No age should return false")
    print("✓ test_user_is_adult passed")
end

local function test_user_service()
    local service = UserService.new()
    local user = User.new("Eve", "eve@example.com", 30)

    service:add_user(user)
    assert(service:count() == 1, "Count should be 1 after adding user")

    local found = service:find_by_email("eve@example.com")
    assert(found ~= nil, "Should find user by email")
    assert(found.name == "Eve", "Found user should have correct name")

    local not_found = service:find_by_email("unknown@example.com")
    assert(not_found == nil, "Should return nil for unknown email")

    print("✓ test_user_service passed")
end

local function test_user_service_get_adults()
    local service = UserService.new()
    service:add_user(User.new("Adult1", "adult1@example.com", 25))
    service:add_user(User.new("Minor1", "minor1@example.com", 15))
    service:add_user(User.new("Adult2", "adult2@example.com", 30))

    local adults = service:get_adults()
    assert(#adults == 2, "Should return 2 adult users")
    print("✓ test_user_service_get_adults passed")
end

local function test_calculate_average()
    local avg, err = MathUtils.calculate_average({1, 2, 3, 4, 5})
    assert(avg == 3, "Average of 1-5 should be 3")
    assert(err == nil, "Should not return error for valid input")

    local empty_avg, empty_err = MathUtils.calculate_average({})
    assert(empty_avg == nil, "Should return nil for empty table")
    assert(empty_err ~= nil, "Should return error for empty table")

    print("✓ test_calculate_average passed")
end

local function test_sum()
    local total = MathUtils.sum({1, 2, 3, 4, 5})
    assert(total == 15, "Sum of 1-5 should be 15")

    local empty_sum = MathUtils.sum({})
    assert(empty_sum == 0, "Sum of empty table should be 0")

    print("✓ test_sum passed")
end

-- Run all tests
local function run_tests()
    print("\n=== Running Lua Tests ===\n")
    test_user_greet()
    test_user_is_adult()
    test_user_service()
    test_user_service_get_adults()
    test_calculate_average()
    test_sum()
    print("\n=== All Tests Passed! ===\n")
end

-- Execute tests if run directly
if arg and arg[0]:match("sample_test%.lua$") then
    run_tests()
end

-- Export modules for external use
return {
    User = User,
    UserService = UserService,
    MathUtils = MathUtils,
    run_tests = run_tests,
}
