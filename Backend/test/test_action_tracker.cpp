#include "logic_test.h"


TEST_F(logicTest, ActionTrackerUpdate) {
    // TODO: Not implemented in the logic yet
    GTEST_SKIP();
}

TEST_F(logicTest, InvalidActionTrackerUpdate) {
    // TODO: Not implemented in the logic yet
    GTEST_SKIP();
}

TEST_F(logicTest, ActionTrackerDelete) {
    // TODO: Not implemented in the logic yet, unsure if needed
    GTEST_SKIP();
}

TEST_F(logicTest, InvalidActionTrackerDelete) {
    // TODO: Not implemented in the logic yet, unsure if needed
    GTEST_SKIP();
}

TEST_F(logicTest, ActionTrackerCreate) {
    web::json::value requestBody;
    requestBody[U("user")] = web::json::value::string(U("guest"));
    requestBody[U("name")] = web::json::value::string(U("Cycling"));
    requestBody[U("date")] = web::json::value::string(U("2024-06-07 13:03:56.000"));
    requestBody[U("type")] = web::json::value::string(U("Cycling"));
    requestBody[U("score")] = web::json::value::number(60);


    // Send a valid POST request
    auto response = sendPostRequest("/actionTracker", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(logicTest, InvalidActionTrackerCreate) {
    web::json::value requestBody;
    // Non existing user
    requestBody[U("user")] = web::json::value::string(U("NotExistingUser"));
    requestBody[U("name")] = web::json::value::string(U("Cycling"));
    requestBody[U("date")] = web::json::value::string(U("2024-06-07 13:03:56.000"));
    requestBody[U("type")] = web::json::value::string(U("Cycling"));
    requestBody[U("score")] = web::json::value::number(60);


    // Send a valid POST request
    auto response = sendPostRequest("/actionTracker", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::BadRequest, response->status_code());
}
