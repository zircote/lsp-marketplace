# Hook test
# Sample Elixir test file for LSP plugin validation.
#
# This file contains various Elixir constructs to test:
# - LSP operations (hover, go to definition, references)
# - Hook validation (formatting, linting)

defmodule User do
  @moduledoc """
  Represents a user in the system.
  """

  defstruct [:name, :email, :age]

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          age: non_neg_integer() | nil
        }

  @doc """
  Returns a greeting message for the user.
  """
  @spec greet(t()) :: String.t()
  def greet(%__MODULE__{name: name}), do: "Hello, #{name}!"

  @doc """
  Checks if the user is an adult (18+).
  """
  @spec adult?(t()) :: boolean()
  def adult?(%__MODULE__{age: nil}), do: false
  def adult?(%__MODULE__{age: age}), do: age >= 18
end

defmodule UserService do
  @moduledoc """
  Service for managing users.
  """

  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_user(user) do
    Agent.update(__MODULE__, fn users -> [user | users] end)
  end

  def find_by_email(email) do
    Agent.get(__MODULE__, fn users ->
      Enum.find(users, fn u -> u.email == email end)
    end)
  end

  def count do
    Agent.get(__MODULE__, &length/1)
  end

  def adults do
    Agent.get(__MODULE__, fn users ->
      Enum.filter(users, &User.adult?/1)
    end)
  end
end

defmodule MathUtils do
  @moduledoc """
  Utility module for calculations.
  """

  @doc """
  Calculates the average of a list of numbers.
  """
  @spec calculate_average([number()]) :: float()
  def calculate_average([]), do: raise(ArgumentError, "Cannot calculate average of empty list")

  def calculate_average(numbers) do
    Enum.sum(numbers) / length(numbers)
  end
end

# TODO: Add more test cases
# FIXME: Handle edge cases

defmodule SampleTest do
  use ExUnit.Case

  test "user greet returns greeting message" do
    user = %User{name: "Alice", email: "alice@example.com"}
    assert User.greet(user) == "Hello, Alice!"
  end

  test "user adult? returns correct value" do
    adult = %User{name: "Bob", email: "bob@example.com", age: 25}
    minor = %User{name: "Charlie", email: "charlie@example.com", age: 15}
    no_age = %User{name: "Dana", email: "dana@example.com"}

    assert User.adult?(adult) == true
    assert User.adult?(minor) == false
    assert User.adult?(no_age) == false
  end

  test "calculate_average returns correct value" do
    assert MathUtils.calculate_average([1, 2, 3, 4, 5]) == 3.0

    assert_raise ArgumentError, fn ->
      MathUtils.calculate_average([])
    end
  end
end
