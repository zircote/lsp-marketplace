// Hook test
/**
 * Sample Kotlin test file for LSP plugin validation.
 *
 * This file contains various Kotlin constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (linting, formatting, testing)
 */
package com.example.test

/**
 * Represents a user in the system.
 */
data class User(
    val name: String,
    val email: String,
    val age: Int? = null
) {
    /**
     * Returns a greeting message for the user.
     */
    fun greet(): String = "Hello, $name!"

    /**
     * Checks if the user is an adult (18+).
     */
    fun isAdult(): Boolean = age != null && age >= 18
}

/**
 * Service for managing users.
 */
class UserService {
    private val users = mutableListOf<User>()

    /**
     * Adds a user to the service.
     */
    fun addUser(user: User) {
        users.add(user)
    }

    /**
     * Finds a user by email.
     */
    fun findByEmail(email: String): User? =
        users.find { it.email == email }

    /**
     * Gets the count of users.
     */
    val count: Int
        get() = users.size

    /**
     * Gets all adult users.
     */
    fun getAdults(): List<User> =
        users.filter { it.isAdult() }
}

/**
 * Calculates the average of a list of numbers.
 */
fun calculateAverage(numbers: List<Double>): Double {
    require(numbers.isNotEmpty()) { "Cannot calculate average of empty list" }
    return numbers.average()
}

// TODO: Add more test cases
// FIXME: Handle edge cases

/**
 * Test functions for User and UserService.
 */
fun main() {
    testUserGreet()
    testUserIsAdult()
    testUserService()
    testCalculateAverage()
    testCoroutines()
    println("All tests passed!")
}

fun testUserGreet() {
    val user = User("Alice", "alice@example.com")
    check(user.greet() == "Hello, Alice!") { "Greet failed" }
}

fun testUserIsAdult() {
    val adult = User("Bob", "bob@example.com", 25)
    val minor = User("Charlie", "charlie@example.com", 15)
    val noAge = User("Dana", "dana@example.com")

    check(adult.isAdult()) { "Adult check failed" }
    check(!minor.isAdult()) { "Minor check failed" }
    check(!noAge.isAdult()) { "No age check failed" }
}

fun testUserService() {
    val service = UserService()
    val user = User("Eve", "eve@example.com", 30)

    service.addUser(user)
    check(service.count == 1) { "Count failed" }

    val found = service.findByEmail("eve@example.com")
    check(found != null) { "Find failed" }
    check(found.name == "Eve") { "Name check failed" }
}

fun testCalculateAverage() {
    val numbers = listOf(1.0, 2.0, 3.0, 4.0, 5.0)
    val avg = calculateAverage(numbers)
    check(avg == 3.0) { "Average failed" }

    try {
        calculateAverage(emptyList())
        error("Should have thrown exception")
    } catch (e: IllegalArgumentException) {
        // Expected
    }
}

// Coroutine example (requires kotlinx-coroutines)
suspend fun fetchUserAsync(id: String): User {
    // Simulated async operation
    return User("Async User", "async@example.com")
}

fun testCoroutines() {
    // Placeholder for coroutine tests
    println("Coroutine support detected")
}
