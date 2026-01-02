// Hook test
/**
 * Sample Java test file for LSP plugin validation.
 *
 * This file contains various Java constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (linting, formatting, testing)
 */
package com.example.test;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Represents a user in the system.
 */
public class User {
    private final String name;
    private final String email;
    private final Integer age;

    public User(String name, String email) {
        this(name, email, null);
    }

    public User(String name, String email, Integer age) {
        this.name = name;
        this.email = email;
        this.age = age;
    }

    /**
     * Returns a greeting message for the user.
     *
     * @return The greeting message
     */
    public String greet() {
        return "Hello, " + name + "!";
    }

    /**
     * Checks if the user is an adult (18+).
     *
     * @return true if the user is 18 or older
     */
    public boolean isAdult() {
        return age != null && age >= 18;
    }

    // Getters
    public String getName() { return name; }
    public String getEmail() { return email; }
    public Optional<Integer> getAge() { return Optional.ofNullable(age); }
}

/**
 * Service for managing users.
 */
class UserService {
    private final List<User> users = new ArrayList<>();

    /**
     * Adds a user to the service.
     *
     * @param user The user to add
     */
    public void addUser(User user) {
        users.add(user);
    }

    /**
     * Finds a user by email.
     *
     * @param email The email to search for
     * @return The user if found
     */
    public Optional<User> findByEmail(String email) {
        return users.stream()
            .filter(u -> u.getEmail().equals(email))
            .findFirst();
    }

    /**
     * Gets the count of users.
     *
     * @return The number of users
     */
    public int getCount() {
        return users.size();
    }

    /**
     * Gets all adult users.
     *
     * @return List of adult users
     */
    public List<User> getAdults() {
        return users.stream()
            .filter(User::isAdult)
            .toList();
    }
}

/**
 * Utility class for calculations.
 */
class MathUtils {
    /**
     * Calculates the average of a list of numbers.
     *
     * @param numbers The list of numbers
     * @return The average
     * @throws IllegalArgumentException if the list is empty
     */
    public static double calculateAverage(List<Double> numbers) {
        if (numbers.isEmpty()) {
            throw new IllegalArgumentException("Cannot calculate average of empty list");
        }
        return numbers.stream()
            .mapToDouble(Double::doubleValue)
            .average()
            .orElse(0.0);
    }
}

// TODO: Add more test cases
// FIXME: Handle edge cases

/**
 * Test class for User and UserService.
 */
class SampleTest {
    public static void main(String[] args) {
        testUserGreet();
        testUserIsAdult();
        testUserService();
        testCalculateAverage();
        System.out.println("All tests passed!");
    }

    static void testUserGreet() {
        User user = new User("Alice", "alice@example.com");
        assert user.greet().equals("Hello, Alice!") : "Greet failed";
    }

    static void testUserIsAdult() {
        User adult = new User("Bob", "bob@example.com", 25);
        User minor = new User("Charlie", "charlie@example.com", 15);
        User noAge = new User("Dana", "dana@example.com");

        assert adult.isAdult() : "Adult check failed";
        assert !minor.isAdult() : "Minor check failed";
        assert !noAge.isAdult() : "No age check failed";
    }

    static void testUserService() {
        UserService service = new UserService();
        User user = new User("Eve", "eve@example.com", 30);

        service.addUser(user);
        assert service.getCount() == 1 : "Count failed";

        Optional<User> found = service.findByEmail("eve@example.com");
        assert found.isPresent() : "Find failed";
        assert found.get().getName().equals("Eve") : "Name check failed";
    }

    static void testCalculateAverage() {
        List<Double> numbers = List.of(1.0, 2.0, 3.0, 4.0, 5.0);
        double avg = MathUtils.calculateAverage(numbers);
        assert avg == 3.0 : "Average failed";

        try {
            MathUtils.calculateAverage(List.of());
            assert false : "Should have thrown exception";
        } catch (IllegalArgumentException e) {
            // Expected
        }
    }
}
