// Hook test
/**
 * Sample C# test file for LSP plugin validation.
 *
 * This file contains various C# constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (linting, formatting, testing)
 */

using System;
using System.Collections.Generic;
using System.Linq;

namespace Example.Tests;

/// <summary>
/// Represents a user in the system.
/// </summary>
public record User(string Name, string Email, int? Age = null)
{
    /// <summary>
    /// Returns a greeting message for the user.
    /// </summary>
    public string Greet() => $"Hello, {Name}!";

    /// <summary>
    /// Checks if the user is an adult (18+).
    /// </summary>
    public bool IsAdult() => Age.HasValue && Age.Value >= 18;
}

/// <summary>
/// Service for managing users.
/// </summary>
public class UserService
{
    private readonly List<User> _users = new();

    /// <summary>
    /// Adds a user to the service.
    /// </summary>
    public void AddUser(User user) => _users.Add(user);

    /// <summary>
    /// Finds a user by email.
    /// </summary>
    public User? FindByEmail(string email) =>
        _users.FirstOrDefault(u => u.Email == email);

    /// <summary>
    /// Gets the count of users.
    /// </summary>
    public int Count => _users.Count;

    /// <summary>
    /// Gets all adult users.
    /// </summary>
    public IEnumerable<User> GetAdults() =>
        _users.Where(u => u.IsAdult());
}

/// <summary>
/// Utility class for calculations.
/// </summary>
public static class MathUtils
{
    /// <summary>
    /// Calculates the average of a collection of numbers.
    /// </summary>
    public static double CalculateAverage(IEnumerable<double> numbers)
    {
        var list = numbers.ToList();
        if (!list.Any())
        {
            throw new ArgumentException("Cannot calculate average of empty collection");
        }
        return list.Average();
    }
}

// TODO: Add more test cases
// FIXME: Handle edge cases

/// <summary>
/// Test class for User and UserService.
/// </summary>
public class SampleTests
{
    public static void Main()
    {
        TestUserGreet();
        TestUserIsAdult();
        TestUserService();
        TestCalculateAverage();
        TestAsyncPattern();
        Console.WriteLine("All tests passed!");
    }

    static void TestUserGreet()
    {
        var user = new User("Alice", "alice@example.com");
        if (user.Greet() != "Hello, Alice!")
        {
            throw new Exception("Greet test failed");
        }
        Console.WriteLine("TestUserGreet passed");
    }

    static void TestUserIsAdult()
    {
        var adult = new User("Bob", "bob@example.com", 25);
        var minor = new User("Charlie", "charlie@example.com", 15);
        var noAge = new User("Dana", "dana@example.com");

        if (!adult.IsAdult()) throw new Exception("Adult check failed");
        if (minor.IsAdult()) throw new Exception("Minor check failed");
        if (noAge.IsAdult()) throw new Exception("No age check failed");

        Console.WriteLine("TestUserIsAdult passed");
    }

    static void TestUserService()
    {
        var service = new UserService();
        var user = new User("Eve", "eve@example.com", 30);

        service.AddUser(user);
        if (service.Count != 1) throw new Exception("Count test failed");

        var found = service.FindByEmail("eve@example.com");
        if (found is null || found.Name != "Eve")
        {
            throw new Exception("Find test failed");
        }

        Console.WriteLine("TestUserService passed");
    }

    static void TestCalculateAverage()
    {
        var numbers = new[] { 1.0, 2.0, 3.0, 4.0, 5.0 };
        var avg = MathUtils.CalculateAverage(numbers);
        if (Math.Abs(avg - 3.0) > 0.001)
        {
            throw new Exception("Average test failed");
        }

        try
        {
            MathUtils.CalculateAverage(Array.Empty<double>());
            throw new Exception("Should have thrown exception");
        }
        catch (ArgumentException)
        {
            // Expected
        }

        Console.WriteLine("TestCalculateAverage passed");
    }

    static async void TestAsyncPattern()
    {
        // Demonstrate proper async/await usage
        await System.Threading.Tasks.Task.Delay(1);
        Console.WriteLine("TestAsyncPattern passed");
    }
}
