// Hook test
<?php

declare(strict_types=1);

/**
 * Sample PHP test file for LSP plugin validation.
 *
 * This file contains various PHP constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (linting, formatting, testing)
 */

namespace Example\Tests;

/**
 * Represents a user in the system.
 */
class User
{
    public function __construct(
        private readonly string $name,
        private readonly string $email,
        private readonly ?int $age = null
    ) {}

    /**
     * Returns a greeting message for the user.
     */
    public function greet(): string
    {
        return "Hello, {$this->name}!";
    }

    /**
     * Checks if the user is an adult (18+).
     */
    public function isAdult(): bool
    {
        return $this->age !== null && $this->age >= 18;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getEmail(): string
    {
        return $this->email;
    }

    public function getAge(): ?int
    {
        return $this->age;
    }
}

/**
 * Service for managing users.
 */
class UserService
{
    /** @var User[] */
    private array $users = [];

    /**
     * Adds a user to the service.
     */
    public function addUser(User $user): void
    {
        $this->users[] = $user;
    }

    /**
     * Finds a user by email.
     */
    public function findByEmail(string $email): ?User
    {
        foreach ($this->users as $user) {
            if ($user->getEmail() === $email) {
                return $user;
            }
        }
        return null;
    }

    /**
     * Gets the count of users.
     */
    public function count(): int
    {
        return count($this->users);
    }

    /**
     * Gets all adult users.
     *
     * @return User[]
     */
    public function getAdults(): array
    {
        return array_filter($this->users, fn(User $user) => $user->isAdult());
    }
}

/**
 * Calculates the average of an array of numbers.
 *
 * @param float[] $numbers
 * @throws \InvalidArgumentException
 */
function calculateAverage(array $numbers): float
{
    if (empty($numbers)) {
        throw new \InvalidArgumentException('Cannot calculate average of empty array');
    }
    return array_sum($numbers) / count($numbers);
}

// TODO: Add more test cases
// FIXME: Handle edge cases

/**
 * Test class for User and UserService.
 */
class SampleTest
{
    public static function main(): void
    {
        self::testUserGreet();
        self::testUserIsAdult();
        self::testUserService();
        self::testCalculateAverage();
        echo "All tests passed!\n";
    }

    private static function testUserGreet(): void
    {
        $user = new User('Alice', 'alice@example.com');
        assert($user->greet() === 'Hello, Alice!', 'Greet test failed');
        echo "testUserGreet passed\n";
    }

    private static function testUserIsAdult(): void
    {
        $adult = new User('Bob', 'bob@example.com', 25);
        $minor = new User('Charlie', 'charlie@example.com', 15);
        $noAge = new User('Dana', 'dana@example.com');

        assert($adult->isAdult() === true, 'Adult check failed');
        assert($minor->isAdult() === false, 'Minor check failed');
        assert($noAge->isAdult() === false, 'No age check failed');

        echo "testUserIsAdult passed\n";
    }

    private static function testUserService(): void
    {
        $service = new UserService();
        $user = new User('Eve', 'eve@example.com', 30);

        $service->addUser($user);
        assert($service->count() === 1, 'Count test failed');

        $found = $service->findByEmail('eve@example.com');
        assert($found !== null && $found->getName() === 'Eve', 'Find test failed');

        echo "testUserService passed\n";
    }

    private static function testCalculateAverage(): void
    {
        $numbers = [1.0, 2.0, 3.0, 4.0, 5.0];
        $avg = calculateAverage($numbers);
        assert(abs($avg - 3.0) < 0.001, 'Average test failed');

        try {
            calculateAverage([]);
            assert(false, 'Should have thrown exception');
        } catch (\InvalidArgumentException $e) {
            // Expected
        }

        echo "testCalculateAverage passed\n";
    }
}

// Run tests if executed directly
if (php_sapi_name() === 'cli' && basename(__FILE__) === basename($argv[0] ?? '')) {
    SampleTest::main();
}
