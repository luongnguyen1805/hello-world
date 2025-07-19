// test/main_test.cpp
#include <gtest/gtest.h>

TEST(HelloTest, BasicAssertion) {
    std::cout << "First Test\n";
    EXPECT_EQ(1 + 1, 2);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}