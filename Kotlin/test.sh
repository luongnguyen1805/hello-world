#!/bin/zsh

CHECK_COMPILER="$(which kotlinc)"

if [[ "$CHECK_COMPILER" == *"not found"* ]]; then
    echo "kotlinc NOT FOUND"
    exit 1
fi

cd test

# Set the classpath with the required JUnit JARs.
# The separator ':' is for macOS/Linux. Use ';' for Windows.
JUNIT_JAR="junit-platform-console-standalone-1.10.2.jar"
TEST_CLASSPATH=".:$JUNIT_JAR"

# Check if JUnit JAR is present
if [ ! -f "$JUNIT_JAR" ]; then
    echo "Error: The required JUnit JAR file ($JUNIT_JAR) was not found."
    echo "Please download it and place it in this directory."
    exit 1
fi

# Create a build directory for compiled files
mkdir -p build

# Compile the Kotlin test file
echo "Compiling SimpleTest.kt..."
kotlinc main.kt -d build -cp "$JUNIT_JAR"

# Check for compilation errors
if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi

# Run the tests using the JUnit Platform Console Launcher
echo "Running tests..."
java -jar "$JUNIT_JAR" --scan-classpath --class-path build

# The exit code of the java command indicates success or failure
if [ $? -eq 0 ]; then
    echo "All tests passed successfully!"
else
    echo "Some tests failed."
fi