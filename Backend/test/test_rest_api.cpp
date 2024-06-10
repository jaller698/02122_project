#include <gtest/gtest.h>
#include <cpprest/http_client.h>
#include <cpprest/json.h>
#include "../rest/rest_api.h"
#include "../data/database_connector.hpp"
#include <thread>
#include "http_common.h"

class RestAPIEndpointTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Set up any necessary resources before each test
        try {
            dataBaseStart db;
            db.init();
            //RestAPIEndpoint rest_api_endpoint;
            //rest_api_endpoint.listen();
        
        } catch (const std::exception& e) {
            ERROR("Error in top-level of test setup ", e);
        } catch (...) {
            ERROR("Unknown error in top-level of program", std::runtime_error("Unknown error"));
        }
    }
    void TearDown() override {
        dataBaseStart db;
        db.reset();
        // Clean up any resources after each test
    }
};

TEST_F(RestAPIEndpointTest, ValidGetRequest) {

    // Send a valid GET request
    auto response = sendGetRequest("");
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(RestAPIEndpointTest, ValidGetDataRequest) {

    // Send an invalid GET request
    auto response = sendGetRequest("/");
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(RestAPIEndpointTest, ValidPostRequest) {

    // Create a JSON object for the request body
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("Hans"));
    requestBody[U("Password")] = web::json::value::string(U("password1234"));

    // Send a valid POST request
    auto response = sendPostRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::Created, response->status_code());
}

TEST_F (RestAPIEndpointTest, ValidPutRequest) {

    // Create a JSON object for the request body
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("John"));
    requestBody[U("Password")] = web::json::value::string(U("password123"));

    // Send a valid PUT request, currently not implemented
    auto response = sendPutRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::Created, response->status_code());

    // wait for the server to process the request
    sleep (5);

    //test that a second attempt won't be processed (not OK)
    auto badResponse = sendPutRequest("/users", requestBody);
    ASSERT_NE(badResponse, nullptr);
    ASSERT_NE(status_codes::OK, badResponse->status_code());
}

TEST_F (RestAPIEndpointTest, EmptyRequest) {

    // Create an empty JSON object for the request body
    web::json::value requestBody;

    // Send an invalid request
    auto response = sendPostRequest("/notfound", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::BadRequest, response->status_code());
}

TEST_F (RestAPIEndpointTest, EndpointNotFound) {
    
    // Create a JSON object for the request body, it cannot be empty
    web::json::value requestBody;
    requestBody[U("User")] = web::json::value::string(U("John"));

    // Send a request to a non-existing endpoint
    auto response = sendPostRequest("/notfound", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::NotFound, response->status_code());
}