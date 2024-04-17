#include <gtest/gtest.h>
#include <cpprest/http_client.h>
#include <cpprest/json.h>
#include "../rest/rest_api.h"
#include "../data/database_connector.hpp"
#include <thread>

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

    // Helper function to send a POST request with JSON data
    std::unique_ptr<http_response> sendPostRequest(const std::string& endpoint, const web::json::value& jsonBody) {
        web::http::client::http_client client("http://localhost:8080");
        web::http::http_request request(web::http::methods::POST);
        request.set_request_uri(endpoint);
        request.set_body(jsonBody);
        request.headers().set_content_type(U("application/json"));
        http_response response = client.request(request).get();
        return std::make_unique<http_response>(std::move(response));;
    }

    std::unique_ptr<http_response> sendGetRequest(const std::string& endpoint) {
        web::http::client::http_client client("http://localhost:8080");
        web::http::http_request request(web::http::methods::GET);
        request.set_request_uri(endpoint);
        http_response response = client.request(request).get();
        return std::make_unique<http_response>(std::move(response));;
    }

    std::unique_ptr<http_response> sendPutRequest(const std::string& endpoint, const web::json::value& jsonBody) {
        web::http::client::http_client client("http://localhost:8080");
        web::http::http_request request(web::http::methods::PUT);
        request.set_request_uri(endpoint);
        request.set_body(jsonBody);
        request.headers().set_content_type(U("application/json"));
        http_response response = client.request(request).get();
        return std::make_unique<http_response>(std::move(response));;
    }
};

TEST_F(RestAPIEndpointTest, ValidGetRequest) {

    // Send a valid GET request
    auto response = sendGetRequest("");
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(RestAPIEndpointTest, ValidGetDataRequest) {

    // Send an invalid GET request
    auto response = sendGetRequest("/users");
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(RestAPIEndpointTest, ValidPostRequest) {

    // Create a JSON object for the request body
    web::json::value requestBody;
    requestBody[U("name")] = web::json::value::string(U("John"));
    requestBody[U("age")] = web::json::value::number(25);

    // Send a valid POST request
    auto response = sendPostRequest("/questions", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());
}

TEST_F(RestAPIEndpointTest, InvalidPostRequest) {

    // Create an empty JSON object for the request body
    web::json::value requestBody;

    // Send an invalid POST request
    auto response = sendPostRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::BadRequest, response->status_code());
}

TEST_F (RestAPIEndpointTest, ValidPutRequest) {

    // Create a JSON object for the request body
    web::json::value requestBody;
    requestBody[U("userID")] = web::json::value::string(U("John"));
    requestBody[U("password")] = web::json::value::string(U("password123"));

    // Send a valid PUT request, currently not implemented
    auto response = sendPutRequest("/users", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    //test that a second attempt will return 304
    auto badResponse = sendPutRequest("/users", requestBody);
    ASSERT_NE(badResponse, nullptr);
    ASSERT_EQ(status_codes::NotModified, badResponse->status_code());
}