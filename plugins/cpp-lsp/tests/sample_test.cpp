// Hook test
/**
 * Sample C++ test file for LSP plugin validation.
 *
 * This file contains various C++ constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (linting, formatting, testing)
 */

#include <iostream>
#include <memory>
#include <optional>
#include <string>
#include <vector>

/**
 * Represents a user in the system.
 */
class User {
public:
    User(std::string name, std::string email)
        : name_(std::move(name)), email_(std::move(email)), age_(std::nullopt) {}

    User(std::string name, std::string email, int age)
        : name_(std::move(name)), email_(std::move(email)), age_(age) {}

    /**
     * Returns a greeting message for the user.
     */
    [[nodiscard]] std::string greet() const {
        return "Hello, " + name_ + "!";
    }

    /**
     * Checks if the user is an adult (18+).
     */
    [[nodiscard]] bool isAdult() const {
        return age_.has_value() && age_.value() >= 18;
    }

    // Getters
    [[nodiscard]] const std::string& getName() const { return name_; }
    [[nodiscard]] const std::string& getEmail() const { return email_; }
    [[nodiscard]] std::optional<int> getAge() const { return age_; }

private:
    std::string name_;
    std::string email_;
    std::optional<int> age_;
};

/**
 * Service for managing users.
 */
class UserService {
public:
    /**
     * Adds a user to the service.
     */
    void addUser(std::unique_ptr<User> user) {
        users_.push_back(std::move(user));
    }

    /**
     * Finds a user by email.
     */
    [[nodiscard]] const User* findByEmail(const std::string& email) const {
        for (const auto& user : users_) {
            if (user->getEmail() == email) {
                return user.get();
            }
        }
        return nullptr;
    }

    /**
     * Gets the count of users.
     */
    [[nodiscard]] size_t getCount() const { return users_.size(); }

    /**
     * Gets all adult users.
     */
    [[nodiscard]] std::vector<const User*> getAdults() const {
        std::vector<const User*> adults;
        for (const auto& user : users_) {
            if (user->isAdult()) {
                adults.push_back(user.get());
            }
        }
        return adults;
    }

private:
    std::vector<std::unique_ptr<User>> users_;
};

/**
 * Calculates the average of a vector of numbers.
 */
[[nodiscard]] double calculateAverage(const std::vector<double>& numbers) {
    if (numbers.empty()) {
        throw std::invalid_argument("Cannot calculate average of empty vector");
    }
    double sum = 0.0;
    for (double n : numbers) {
        sum += n;
    }
    return sum / static_cast<double>(numbers.size());
}

// TODO: Add more test cases
// FIXME: Handle edge cases

/**
 * Test functions
 */
void testUserGreet() {
    User user("Alice", "alice@example.com");
    if (user.greet() != "Hello, Alice!") {
        throw std::runtime_error("Greet test failed");
    }
    std::cout << "testUserGreet passed\n";
}

void testUserIsAdult() {
    User adult("Bob", "bob@example.com", 25);
    User minor("Charlie", "charlie@example.com", 15);
    User noAge("Dana", "dana@example.com");

    if (!adult.isAdult()) throw std::runtime_error("Adult check failed");
    if (minor.isAdult()) throw std::runtime_error("Minor check failed");
    if (noAge.isAdult()) throw std::runtime_error("No age check failed");

    std::cout << "testUserIsAdult passed\n";
}

void testUserService() {
    UserService service;
    service.addUser(std::make_unique<User>("Eve", "eve@example.com", 30));

    if (service.getCount() != 1) {
        throw std::runtime_error("Count test failed");
    }

    const User* found = service.findByEmail("eve@example.com");
    if (found == nullptr || found->getName() != "Eve") {
        throw std::runtime_error("Find test failed");
    }

    std::cout << "testUserService passed\n";
}

void testCalculateAverage() {
    std::vector<double> numbers = {1.0, 2.0, 3.0, 4.0, 5.0};
    double avg = calculateAverage(numbers);
    if (avg != 3.0) {
        throw std::runtime_error("Average test failed");
    }

    try {
        calculateAverage({});
        throw std::runtime_error("Should have thrown exception");
    } catch (const std::invalid_argument&) {
        // Expected
    }

    std::cout << "testCalculateAverage passed\n";
}

int main() {
    try {
        testUserGreet();
        testUserIsAdult();
        testUserService();
        testCalculateAverage();
        std::cout << "All tests passed!\n";
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Test failed: " << e.what() << "\n";
        return 1;
    }
}
