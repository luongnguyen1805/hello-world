import unittest

# This is the function we want to test.
# It takes two numbers and returns their sum.
def add_numbers(a, b):
    """
    Adds two numbers and returns the sum.
    """
    return a + b

# This is our unit test class.
# It must inherit from unittest.TestCase.
class TestAddNumbers(unittest.TestCase):

    # Each test method must start with the prefix `test_`.
    def test_positive_numbers(self):
        """
        Tests the addition of two positive numbers.
        """
        result = add_numbers(1, 1)
        # Use an assertion to check if the result is as expected.
        self.assertEqual(result, 2)

    def test_negative_numbers(self):
        """
        Tests the addition of two negative numbers.
        """
        result = add_numbers(-1, -1)
        self.assertEqual(result, -2)

    def test_mixed_numbers(self):
        """
        Tests the addition of a positive and a negative number.
        """
        result = add_numbers(5, -3)
        self.assertEqual(result, 2)

# This block allows the script to be run from the command line.
# It discovers and runs all tests within the file.
if __name__ == '__main__':
    unittest.main()
