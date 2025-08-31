import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.assertEquals

// The class containing our tests
class SimpleTest {

    // A simple function to test
    private fun addNumbers(a: Int, b: Int): Int {
        return a + b
    }

    // A test method must be annotated with @Test
    @Test
    fun `test that 1 plus 1 equals 2`() {
        // Arrange
        val a = 1
        val b = 1
        val expected = 2

        // Act
        val actual = addNumbers(a, b)

        // Assert
        assertEquals(expected, actual, "The sum of 1 + 1 should be 2")
    }

    @Test
    fun `test negative numbers`() {
        val actual = addNumbers(-10, -5)
        assertEquals(-15, actual, "The sum of -10 + -5 should be -15")
    }
}
