# Hook test
"""
Sample Python test file for LSP plugin validation.

This file contains various Python constructs to test:
- LSP operations (hover, go to definition, references)
- Hook validation (linting, type checking, formatting)
"""

from dataclasses import dataclass
from typing import Optional


@dataclass
class User:
    """Represents a user in the system."""

    name: str
    email: str
    age: Optional[int] = None

    def greet(self) -> str:
        """Return a greeting message for the user."""
        return f"Hello, {self.name}!"

    def is_adult(self) -> bool:
        """Check if the user is an adult (18+)."""
        if self.age is None:
            return False
        return self.age >= 18


def calculate_average(numbers: list[float]) -> float:
    """
    Calculate the average of a list of numbers.

    Args:
        numbers: A list of numeric values.

    Returns:
        The arithmetic mean of the numbers.

    Raises:
        ValueError: If the list is empty.
    """
    if not numbers:
        raise ValueError("Cannot calculate average of empty list")
    return sum(numbers) / len(numbers)


def process_users(users: list[User]) -> dict[str, int]:
    """
    Process a list of users and return statistics.

    Args:
        users: List of User objects.

    Returns:
        Dictionary with user statistics.
    """
    total = len(users)
    adults = sum(1 for u in users if u.is_adult())
    with_email = sum(1 for u in users if "@" in u.email)

    return {
        "total": total,
        "adults": adults,
        "with_email": with_email,
    }


# TODO: Add more test cases
# FIXME: Handle edge cases for empty user list


class TestUser:
    """Test cases for the User class."""

    def test_greet(self) -> None:
        """Test the greet method."""
        user = User(name="Alice", email="alice@example.com")
        assert user.greet() == "Hello, Alice!"

    def test_is_adult_with_age(self) -> None:
        """Test is_adult with age specified."""
        adult = User(name="Bob", email="bob@example.com", age=25)
        minor = User(name="Charlie", email="charlie@example.com", age=15)

        assert adult.is_adult() is True
        assert minor.is_adult() is False

    def test_is_adult_without_age(self) -> None:
        """Test is_adult without age specified."""
        user = User(name="Dana", email="dana@example.com")
        assert user.is_adult() is False


class TestCalculateAverage:
    """Test cases for the calculate_average function."""

    def test_average_positive_numbers(self) -> None:
        """Test average of positive numbers."""
        result = calculate_average([1.0, 2.0, 3.0, 4.0, 5.0])
        assert result == 3.0

    def test_average_single_number(self) -> None:
        """Test average of single number."""
        result = calculate_average([42.0])
        assert result == 42.0

    def test_average_empty_list_raises(self) -> None:
        """Test that empty list raises ValueError."""
        import pytest

        with pytest.raises(ValueError, match="Cannot calculate average"):
            calculate_average([])
