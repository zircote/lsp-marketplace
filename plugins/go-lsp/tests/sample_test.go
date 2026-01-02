// Hook test
// Package main provides sample Go code for LSP plugin validation.
//
// This file contains various Go constructs to test:
// - LSP operations (hover, go to definition, references)
// - Hook validation (linting, formatting, testing)
package main

import (
	"errors"
	"testing"
)

// User represents a user in the system.
type User struct {
	Name  string
	Email string
	Age   int
}

// Greet returns a greeting message for the user.
func (u *User) Greet() string {
	return "Hello, " + u.Name + "!"
}

// IsAdult checks if the user is an adult (18+).
func (u *User) IsAdult() bool {
	return u.Age >= 18
}

// UserService manages users.
type UserService struct {
	users []User
}

// NewUserService creates a new UserService.
func NewUserService() *UserService {
	return &UserService{
		users: make([]User, 0),
	}
}

// AddUser adds a user to the service.
func (s *UserService) AddUser(user User) {
	s.users = append(s.users, user)
}

// FindByEmail finds a user by email.
func (s *UserService) FindByEmail(email string) (*User, bool) {
	for i := range s.users {
		if s.users[i].Email == email {
			return &s.users[i], true
		}
	}
	return nil, false
}

// Count returns the number of users.
func (s *UserService) Count() int {
	return len(s.users)
}

// CalculateAverage calculates the average of a slice of numbers.
func CalculateAverage(numbers []float64) (float64, error) {
	if len(numbers) == 0 {
		return 0, errors.New("cannot calculate average of empty slice")
	}

	var sum float64
	for _, n := range numbers {
		sum += n
	}
	return sum / float64(len(numbers)), nil
}

// TODO: Add more test cases
// FIXME: Handle edge cases

func TestUserGreet(t *testing.T) {
	user := User{Name: "Alice", Email: "alice@example.com", Age: 25}
	expected := "Hello, Alice!"
	if got := user.Greet(); got != expected {
		t.Errorf("Greet() = %q, want %q", got, expected)
	}
}

func TestUserIsAdult(t *testing.T) {
	tests := []struct {
		name     string
		age      int
		expected bool
	}{
		{"adult", 25, true},
		{"minor", 15, false},
		{"exact", 18, true},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			user := User{Name: "Test", Email: "test@example.com", Age: tt.age}
			if got := user.IsAdult(); got != tt.expected {
				t.Errorf("IsAdult() = %v, want %v", got, tt.expected)
			}
		})
	}
}

func TestUserService(t *testing.T) {
	service := NewUserService()

	user := User{Name: "Bob", Email: "bob@example.com", Age: 30}
	service.AddUser(user)

	if service.Count() != 1 {
		t.Errorf("Count() = %d, want 1", service.Count())
	}

	found, ok := service.FindByEmail("bob@example.com")
	if !ok {
		t.Error("FindByEmail() did not find user")
	}
	if found.Name != "Bob" {
		t.Errorf("found.Name = %q, want %q", found.Name, "Bob")
	}
}

func TestCalculateAverage(t *testing.T) {
	t.Run("positive numbers", func(t *testing.T) {
		avg, err := CalculateAverage([]float64{1, 2, 3, 4, 5})
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if avg != 3 {
			t.Errorf("CalculateAverage() = %f, want 3", avg)
		}
	})

	t.Run("empty slice", func(t *testing.T) {
		_, err := CalculateAverage([]float64{})
		if err == nil {
			t.Error("expected error for empty slice")
		}
	})
}

func BenchmarkCalculateAverage(b *testing.B) {
	numbers := make([]float64, 1000)
	for i := range numbers {
		numbers[i] = float64(i)
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		CalculateAverage(numbers)
	}
}
