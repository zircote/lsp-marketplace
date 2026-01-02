/**
 * Sample Swift test file for LSP plugin validation.
 *
 * This file contains various Swift constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (formatting, linting, building)
 */

import Foundation

/// Represents a user in the system.
struct User {
    let name: String
    let email: String
    let age: Int?

    init(name: String, email: String, age: Int? = nil) {
        self.name = name
        self.email = email
        self.age = age
    }

    /// Returns a greeting message for the user.
    func greet() -> String {
        "Hello, \(name)!"
    }

    /// Checks if the user is an adult (18+).
    func isAdult() -> Bool {
        guard let age = age else { return false }
        return age >= 18
    }
}

/// Service for managing users.
class UserService {
    private var users: [User] = []

    /// Adds a user to the service.
    func addUser(_ user: User) {
        users.append(user)
    }

    /// Finds a user by email.
    func findByEmail(_ email: String) -> User? {
        users.first { $0.email == email }
    }

    /// Gets the count of users.
    var count: Int {
        users.count
    }

    /// Gets all adult users.
    var adults: [User] {
        users.filter { $0.isAdult() }
    }
}

/// Calculates the average of an array of numbers.
/// - Parameter numbers: Array of numbers to average
/// - Throws: Error if the array is empty
/// - Returns: The average value
func calculateAverage(_ numbers: [Double]) throws -> Double {
    guard !numbers.isEmpty else {
        throw NSError(domain: "MathError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot calculate average of empty array"])
    }
    return numbers.reduce(0, +) / Double(numbers.count)
}

// TODO: Add more test cases
// FIXME: Handle edge cases

/// Test class for User and UserService.
enum SampleTests {
    static func main() {
        testUserGreet()
        testUserIsAdult()
        testUserService()
        testCalculateAverage()
        testAsyncPattern()
        print("All tests passed!")
    }

    static func testUserGreet() {
        let user = User(name: "Alice", email: "alice@example.com")
        assert(user.greet() == "Hello, Alice!", "Greet test failed")
        print("testUserGreet passed")
    }

    static func testUserIsAdult() {
        let adult = User(name: "Bob", email: "bob@example.com", age: 25)
        let minor = User(name: "Charlie", email: "charlie@example.com", age: 15)
        let noAge = User(name: "Dana", email: "dana@example.com")

        assert(adult.isAdult() == true, "Adult check failed")
        assert(minor.isAdult() == false, "Minor check failed")
        assert(noAge.isAdult() == false, "No age check failed")

        print("testUserIsAdult passed")
    }

    static func testUserService() {
        let service = UserService()
        let user = User(name: "Eve", email: "eve@example.com", age: 30)

        service.addUser(user)
        assert(service.count == 1, "Count test failed")

        if let found = service.findByEmail("eve@example.com") {
            assert(found.name == "Eve", "Find test failed")
        } else {
            assertionFailure("Find test failed - user not found")
        }

        print("testUserService passed")
    }

    static func testCalculateAverage() {
        let numbers = [1.0, 2.0, 3.0, 4.0, 5.0]
        do {
            let avg = try calculateAverage(numbers)
            assert(abs(avg - 3.0) < 0.001, "Average test failed")
        } catch {
            assertionFailure("Average calculation threw unexpected error")
        }

        do {
            _ = try calculateAverage([])
            assertionFailure("Should have thrown error")
        } catch {
            // Expected
        }

        print("testCalculateAverage passed")
    }

    static func testAsyncPattern() {
        // Demonstrate proper async/await usage
        Task {
            try await Task.sleep(nanoseconds: 1_000_000)
            print("testAsyncPattern passed")
        }
    }
}

// Run tests
SampleTests.main()
