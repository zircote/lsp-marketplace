/**
 * Sample TypeScript test file for LSP plugin validation.
 *
 * This file contains various TypeScript constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (linting, type checking, formatting)
 */

interface User {
  name: string;
  email: string;
  age?: number;
}

class UserService {
  private users: User[] = [];

  /**
   * Add a new user to the service.
   */
  addUser(user: User): void {
    this.users.push(user);
  }

  /**
   * Find a user by email address.
   */
  findByEmail(email: string): User | undefined {
    return this.users.find((u) => u.email === email);
  }

  /**
   * Get all adult users (18+).
   */
  getAdults(): User[] {
    return this.users.filter((u) => u.age !== undefined && u.age >= 18);
  }

  /**
   * Get the total number of users.
   */
  get count(): number {
    return this.users.length;
  }
}

/**
 * Calculate the average of an array of numbers.
 */
function calculateAverage(numbers: number[]): number {
  if (numbers.length === 0) {
    throw new Error("Cannot calculate average of empty array");
  }
  return numbers.reduce((sum, n) => sum + n, 0) / numbers.length;
}

/**
 * Process users and return statistics.
 */
function processUsers(users: User[]): Record<string, number> {
  const total = users.length;
  const adults = users.filter((u) => u.age !== undefined && u.age >= 18).length;
  const withEmail = users.filter((u) => u.email.includes("@")).length;

  return {
    total,
    adults,
    withEmail,
  };
}

// TODO: Add more test cases
// FIXME: Handle edge cases

// Test cases
describe("UserService", () => {
  let service: UserService;

  beforeEach(() => {
    service = new UserService();
  });

  it("should add a user", () => {
    const user: User = { name: "Alice", email: "alice@example.com" };
    service.addUser(user);
    expect(service.count).toBe(1);
  });

  it("should find user by email", () => {
    const user: User = { name: "Bob", email: "bob@example.com", age: 25 };
    service.addUser(user);
    const found = service.findByEmail("bob@example.com");
    expect(found).toEqual(user);
  });

  it("should get adult users", () => {
    service.addUser({ name: "Adult", email: "adult@example.com", age: 25 });
    service.addUser({ name: "Minor", email: "minor@example.com", age: 15 });
    const adults = service.getAdults();
    expect(adults).toHaveLength(1);
  });
});

describe("calculateAverage", () => {
  it("should calculate average of positive numbers", () => {
    expect(calculateAverage([1, 2, 3, 4, 5])).toBe(3);
  });

  it("should throw on empty array", () => {
    expect(() => calculateAverage([])).toThrow("Cannot calculate average");
  });
});

export { User, UserService, calculateAverage, processUsers };
