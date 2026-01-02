-- Hook test
{-# LANGUAGE OverloadedStrings #-}

-- | Sample Haskell module for LSP plugin validation.
--
-- This file contains various Haskell constructs to test:
-- - LSP operations (hover, go to definition, type information)
-- - Hook validation (linting, formatting, type checking)
module SampleTest where

import Data.List (find)
import Data.Maybe (fromMaybe, isJust)
import Test.HUnit

-- | Represents a user in the system.
data User = User
  { userName :: String,
    userEmail :: String,
    userAge :: Int
  }
  deriving (Show, Eq)

-- | Creates a greeting message for the user.
greet :: User -> String
greet user = "Hello, " ++ userName user ++ "!"

-- | Checks if the user is an adult (18+).
isAdult :: User -> Bool
isAdult user = userAge user >= 18

-- | Service for managing users.
data UserService = UserService
  { users :: [User]
  }
  deriving (Show)

-- | Creates a new empty UserService.
newUserService :: UserService
newUserService = UserService {users = []}

-- | Adds a user to the service.
addUser :: User -> UserService -> UserService
addUser user service = service {users = user : users service}

-- | Finds a user by email address.
findByEmail :: String -> UserService -> Maybe User
findByEmail email service = find (\u -> userEmail u == email) (users service)

-- | Returns the number of users in the service.
count :: UserService -> Int
count = length . users

-- | Calculates the average of a list of numbers.
-- Returns Nothing if the list is empty.
calculateAverage :: [Double] -> Maybe Double
calculateAverage [] = Nothing
calculateAverage xs = Just (sum xs / fromIntegral (length xs))

-- | Safe division that returns Nothing for division by zero.
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide x y = Just (x / y)

-- | Filters adult users from a list.
filterAdults :: [User] -> [User]
filterAdults = filter isAdult

-- | Gets the average age of users, or 0 if no users.
averageAge :: [User] -> Double
averageAge [] = 0
averageAge us = fromMaybe 0 (calculateAverage ages)
  where
    ages = map (fromIntegral . userAge) us

-- TODO: Add more comprehensive user validation
-- FIXME: Handle email validation properly

-- Test cases using HUnit

testUserGreet :: Test
testUserGreet =
  TestCase $
    assertEqual
      "greet should return proper greeting"
      "Hello, Alice!"
      (greet alice)
  where
    alice = User {userName = "Alice", userEmail = "alice@example.com", userAge = 25}

testUserIsAdult :: Test
testUserIsAdult =
  TestList
    [ TestCase $ assertEqual "25 year old is adult" True (isAdult adult),
      TestCase $ assertEqual "15 year old is not adult" False (isAdult minor),
      TestCase $ assertEqual "18 year old is adult" True (isAdult exact)
    ]
  where
    adult = User {userName = "Adult", userEmail = "adult@example.com", userAge = 25}
    minor = User {userName = "Minor", userEmail = "minor@example.com", userAge = 15}
    exact = User {userName = "Exact", userEmail = "exact@example.com", userAge = 18}

testUserService :: Test
testUserService =
  TestList
    [ TestCase $ assertEqual "initial count is 0" 0 (count service),
      TestCase $ assertEqual "count after adding user" 1 (count service'),
      TestCase $ assertEqual "findByEmail finds user" True (isJust found),
      TestCase $ assertEqual "found user has correct name" "Bob" (maybe "" userName found)
    ]
  where
    service = newUserService
    bob = User {userName = "Bob", userEmail = "bob@example.com", userAge = 30}
    service' = addUser bob service
    found = findByEmail "bob@example.com" service'

testCalculateAverage :: Test
testCalculateAverage =
  TestList
    [ TestCase $ assertEqual "average of [1,2,3,4,5]" (Just 3.0) (calculateAverage [1, 2, 3, 4, 5]),
      TestCase $ assertEqual "average of empty list" Nothing (calculateAverage []),
      TestCase $ assertEqual "average of single element" (Just 42.0) (calculateAverage [42.0])
    ]

testSafeDivide :: Test
testSafeDivide =
  TestList
    [ TestCase $ assertEqual "10 / 2 = 5" (Just 5.0) (safeDivide 10 2),
      TestCase $ assertEqual "division by zero" Nothing (safeDivide 10 0),
      TestCase $ assertEqual "0 / 5 = 0" (Just 0.0) (safeDivide 0 5)
    ]

testFilterAdults :: Test
testFilterAdults =
  TestCase $ assertEqual "filter adults from mixed list" 2 (length (filterAdults mixedUsers))
  where
    mixedUsers =
      [ User {userName = "Adult1", userEmail = "a1@example.com", userAge = 25},
        User {userName = "Minor1", userEmail = "m1@example.com", userAge = 15},
        User {userName = "Adult2", userEmail = "a2@example.com", userAge = 30},
        User {userName = "Minor2", userEmail = "m2@example.com", userAge = 12}
      ]

testAverageAge :: Test
testAverageAge =
  TestList
    [ TestCase $ assertEqual "average age of users" 25.0 (averageAge testUsers),
      TestCase $ assertEqual "average age of empty list" 0.0 (averageAge [])
    ]
  where
    testUsers =
      [ User {userName = "User1", userEmail = "u1@example.com", userAge = 20},
        User {userName = "User2", userEmail = "u2@example.com", userAge = 30}
      ]

-- | Main test suite
tests :: Test
tests =
  TestList
    [ TestLabel "User Greet" testUserGreet,
      TestLabel "User IsAdult" testUserIsAdult,
      TestLabel "UserService" testUserService,
      TestLabel "Calculate Average" testCalculateAverage,
      TestLabel "Safe Divide" testSafeDivide,
      TestLabel "Filter Adults" testFilterAdults,
      TestLabel "Average Age" testAverageAge
    ]

-- | Run all tests
main :: IO ()
main = do
  _ <- runTestTT tests
  return ()
