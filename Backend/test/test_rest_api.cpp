#include <gtest/gtest.h>
#include <cpprest/http_client.h>
#include <cpprest/json.h>
#include "../rest/rest_api.h"

class RestAPIEndpointTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Set up any necessary resources before each test
    }

    void TearDown() override {
        // Clean up any resources after each test
    }

    // Helper function to send a POST request with JSON data
    void sendPostRequest(const std::string& endpoint, const web::json::value& jsonBody) {
        web::http::client::http_client client("http://localhost:8080");
        web::http::http_request request(web::http::methods::POST);
        request.set_request_uri(endpoint);
        request.set_body(jsonBody);
        client.request(request).wait();
    }
};

TEST_F(RestAPIEndpointTest, ValidPostRequest) {
    RestAPIEndpoint endpoint;

    // Create a JSON object for the request body
    web::json::value requestBody;
    requestBody[U("name")] = web::json::value::string(U("John"));
    requestBody[U("age")] = web::json::value::number(25);

    // Send a valid POST request
    sendPostRequest("/api/endpoint", requestBody);

    // TODO: Add your assertions here
    // For example, you can check if the response status code is OK
    // ASSERT_EQ(status_codes::OK, response.status_code());
}

TEST_F(RestAPIEndpointTest, InvalidPostRequest) {
    RestAPIEndpoint endpoint;

    // Create an empty JSON object for the request body
    web::json::value requestBody;

    // Send an invalid POST request
    sendPostRequest("/api/endpoint", requestBody);

    // TODO: Add your assertions here
    // For example, you can check if the response status code is BadRequest
    // ASSERT_EQ(status_codes::BadRequest, response.status_code());
}