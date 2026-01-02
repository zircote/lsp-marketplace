/**
 * Sample Scala test file for LSP plugin validation.
 *
 * This file contains various Scala constructs to test:
 * - LSP operations (hover, go to definition, references)
 * - Hook validation (formatting, linting)
 */

package example.tests

/** Represents a user in the system. */
case class User(name: String, email: String, age: Option[Int] = None) {

  /** Returns a greeting message for the user. */
  def greet: String = s"Hello, $name!"

  /** Checks if the user is an adult (18+). */
  def isAdult: Boolean = age.exists(_ >= 18)
}

/** Service for managing users. */
class UserService {
  private var users: List[User] = List.empty

  /** Adds a user to the service. */
  def addUser(user: User): Unit = {
    users = users :+ user
  }

  /** Finds a user by email. */
  def findByEmail(email: String): Option[User] = {
    users.find(_.email == email)
  }

  /** Gets the count of users. */
  def count: Int = users.length

  /** Gets all adult users. */
  def adults: List[User] = users.filter(_.isAdult)
}

/** Utility object for calculations. */
object MathUtils {

  /** Calculates the average of a sequence of numbers. */
  def calculateAverage(numbers: Seq[Double]): Double = {
    require(numbers.nonEmpty, "Cannot calculate average of empty sequence")
    numbers.sum / numbers.length
  }
}

// TODO: Add more test cases
// FIXME: Handle edge cases

/** Test object for User and UserService. */
object SampleTests extends App {

  def testUserGreet(): Unit = {
    val user = User("Alice", "alice@example.com")
    assert(user.greet == "Hello, Alice!", "Greet test failed")
    println("testUserGreet passed")
  }

  def testUserIsAdult(): Unit = {
    val adult = User("Bob", "bob@example.com", Some(25))
    val minor = User("Charlie", "charlie@example.com", Some(15))
    val noAge = User("Dana", "dana@example.com")

    assert(adult.isAdult, "Adult check failed")
    assert(!minor.isAdult, "Minor check failed")
    assert(!noAge.isAdult, "No age check failed")

    println("testUserIsAdult passed")
  }

  def testUserService(): Unit = {
    val service = new UserService
    val user = User("Eve", "eve@example.com", Some(30))

    service.addUser(user)
    assert(service.count == 1, "Count test failed")

    service.findByEmail("eve@example.com") match {
      case Some(found) => assert(found.name == "Eve", "Find test failed")
      case None        => throw new AssertionError("Find test failed - user not found")
    }

    println("testUserService passed")
  }

  def testCalculateAverage(): Unit = {
    val numbers = Seq(1.0, 2.0, 3.0, 4.0, 5.0)
    val avg = MathUtils.calculateAverage(numbers)
    assert(math.abs(avg - 3.0) < 0.001, "Average test failed")

    try {
      MathUtils.calculateAverage(Seq.empty)
      throw new AssertionError("Should have thrown exception")
    } catch {
      case _: IllegalArgumentException => // Expected
    }

    println("testCalculateAverage passed")
  }

  // Run tests
  testUserGreet()
  testUserIsAdult()
  testUserService()
  testCalculateAverage()
  println("All tests passed!")
}
