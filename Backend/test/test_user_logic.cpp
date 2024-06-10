#include "logic_test.h"
#include "openssl/sha.h"

TEST_F(logicTest, ValidSignUp) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("Hans"));
    requestBody[U("Password")] = web::json::value::string(U("password1234"));

    // Send a valid POST request
    auto response = sendPostRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::Created, response->status_code());
}

TEST_F(logicTest, SignUpWithExistingUser) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("Hans"));
    requestBody[U("Password")] = web::json::value::string(U("password1234"));

    // Send a valid POST request
    auto response = sendPostRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::Created, response->status_code());

    // send the request again
    response = sendPostRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::Conflict, response->status_code());
}

TEST_F(logicTest, ValidLogin) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("guest"));
    requestBody[U("Password")] = web::json::value::string("password");

    auto response = sendGetRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(logicTest, LoginWithNonExistingUser) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("nonExistingUser"));
    requestBody[U("Password")] = web::json::value::string("password");

    auto response = sendGetRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::Unauthorized, response->status_code());
}

TEST_F(logicTest, GetUserScore) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("guest"));

    auto response = sendGetRequest("/userScore", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    // assert that the response is a number
    auto responseJson = response->extract_json().get();
    ASSERT_TRUE(responseJson.is_number());

}

TEST_F(logicTest, UpdateUserScore) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("guest"));
    requestBody[U("Score")] = web::json::value::number(100);

    auto response = sendGetRequest("/userScore", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(logicTest, UpdateUserScoreWithNonExistingUser) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("nonExistingUser"));
    requestBody[U("Score")] = web::json::value::number(100);

    auto response = sendGetRequest("/userScore", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::InternalError, response->status_code());
}


TEST_F(logicTest, getCategorizedCarbonScore) {
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("guest"));

    auto response = sendGetRequest("/carbonScoreCategories", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    // assert that the response is a map
    auto responseJson = response->extract_json().get();
    ASSERT_TRUE(responseJson.is_object());
}