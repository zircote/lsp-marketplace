# Hook test
# frozen_string_literal: true

# Sample Ruby test file for LSP plugin validation.
#
# This file contains various Ruby constructs to test:
# - LSP operations (hover, go to definition, references)
# - Hook validation (linting, formatting, testing)

# Represents a user in the system.
class User
  attr_reader :name, :email, :age

  def initialize(name, email, age = nil)
    @name = name
    @email = email
    @age = age
  end

  # Returns a greeting message for the user.
  def greet
    "Hello, #{name}!"
  end

  # Checks if the user is an adult (18+).
  def adult?
    age && age >= 18
  end
end

# Service for managing users.
class UserService
  def initialize
    @users = []
  end

  # Adds a user to the service.
  def add_user(user)
    @users << user
  end

  # Finds a user by email.
  def find_by_email(email)
    @users.find { |u| u.email == email }
  end

  # Gets the count of users.
  def count
    @users.length
  end

  # Gets all adult users.
  def adults
    @users.select(&:adult?)
  end
end

# Calculates the average of an array of numbers.
def calculate_average(numbers)
  raise ArgumentError, 'Cannot calculate average of empty array' if numbers.empty?

  numbers.sum.to_f / numbers.length
end

# TODO: Add more test cases
# FIXME: Handle edge cases

# Test specifications
RSpec.describe User do
  describe '#greet' do
    it 'returns a greeting message' do
      user = User.new('Alice', 'alice@example.com')
      expect(user.greet).to eq('Hello, Alice!')
    end
  end

  describe '#adult?' do
    context 'when user has age' do
      it 'returns true for adults' do
        user = User.new('Bob', 'bob@example.com', 25)
        expect(user.adult?).to be true
      end

      it 'returns false for minors' do
        user = User.new('Charlie', 'charlie@example.com', 15)
        expect(user.adult?).to be false
      end
    end

    context 'when user has no age' do
      it 'returns false' do
        user = User.new('Dana', 'dana@example.com')
        expect(user.adult?).to be false
      end
    end
  end
end

RSpec.describe UserService do
  let(:service) { UserService.new }
  let(:user) { User.new('Eve', 'eve@example.com', 30) }

  describe '#add_user' do
    it 'adds a user' do
      service.add_user(user)
      expect(service.count).to eq(1)
    end
  end

  describe '#find_by_email' do
    before { service.add_user(user) }

    it 'finds user by email' do
      found = service.find_by_email('eve@example.com')
      expect(found).to eq(user)
    end

    it 'returns nil for unknown email' do
      found = service.find_by_email('unknown@example.com')
      expect(found).to be_nil
    end
  end

  describe '#adults' do
    it 'returns only adult users' do
      service.add_user(User.new('Adult', 'adult@example.com', 25))
      service.add_user(User.new('Minor', 'minor@example.com', 15))
      expect(service.adults.length).to eq(1)
    end
  end
end

RSpec.describe '#calculate_average' do
  it 'calculates the average of positive numbers' do
    expect(calculate_average([1, 2, 3, 4, 5])).to eq(3.0)
  end

  it 'raises error for empty array' do
    expect { calculate_average([]) }.to raise_error(ArgumentError)
  end
end
