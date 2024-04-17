#define TEST_ENVIROMENT

#include <gtest/gtest.h>
#include "common.h"
#include <cmath>

// test method
double squareRoot(double n) {
    if (n < 0.0) return -1.0;
    return std::sqrt(n);
}

int main(int argc, char** argv) {
    INFO("Running main_test.cpp");
    std::thread rest_api_thread = std::thread([]() {
        RestAPIEndpoint rest_api_endpoint;
        rest_api_endpoint.listen();
    });
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

TEST(SquareRootTest, PositiveNos) { 
    ASSERT_EQ(6, squareRoot(36.0));
    ASSERT_EQ(18.0, squareRoot(324.0));
    ASSERT_EQ(25.4, squareRoot(645.16));
    ASSERT_EQ(0, squareRoot(0.0));
}

TEST(SquareRootTest, NegativeNos) {
    ASSERT_EQ(-1.0, squareRoot(-15.0));
    ASSERT_EQ(-1.0, squareRoot(-0.2));
}