#include <gtest/gtest.h>
#include <cpprest/http_client.h>
#include <cpprest/json.h>

// We need to include the source file to test the class, but I would prefer to include the header file
#include "../rest/rest_api.cpp"

class RestAPIEndpointTest : public ::testing::Test {
protected:
    void SetUp() override {
        // Set up any necessary resources before each test
    }

    void TearDown() override {
        // Clean up any resources after each test
    }

    // Helper function to send a POST request with JSON data
    http_response sendPostRequest(const std::string& endpoint, const web::json::value& jsonBody) {
        web::http::client::http_client client("http://localhost:8080");
        web::http::http_request request(web::http::methods::POST);
        request.set_request_uri(endpoint);
        request.set_body(jsonBody);
        request.headers().set_content_type(U("application/json"));
        http_response response = client.request(request).get();
        return response;
    }

    http_response sendGetRequest(const std::string& endpoint) {
        web::http::client::http_client client("http://localhost:8080");
        web::http::http_request request(web::http::methods::GET);
        request.set_request_uri(endpoint);
        http_response response = client.request(request).get();
        return response;
    }

    http_response sendPutRequest(const std::string& endpoint, const web::json::value& jsonBody) {
        web::http::client::http_client client("http://localhost:8080");
        web::http::http_request request(web::http::methods::PUT);
        request.set_request_uri(endpoint);
        request.set_body(jsonBody);
        request.headers().set_content_type(U("application/json"));
        http_response response = client.request(request).get();
        return response;
    }
};

TEST_F(RestAPIEndpointTest, ValidGetRequest) {

    // Send a valid GET request
    auto response = sendGetRequest("/api/endpoint");
    ASSERT_EQ(status_codes::OK, response.status_code());
}

TEST_F(RestAPIEndpointTest, ValidPostRequest) {

    // Create a JSON object for the request body
    web::json::value requestBody;
    requestBody[U("name")] = web::json::value::string(U("John"));
    requestBody[U("age")] = web::json::value::number(25);

    // Send a valid POST request
    auto response = sendPostRequest("/api/endpoint", requestBody);
    ASSERT_EQ(status_codes::OK, response.status_code());
}

TEST_F(RestAPIEndpointTest, InvalidPostRequest) {

    // Create an empty JSON object for the request body
    web::json::value requestBody;

    // Send an invalid POST request
    auto response = sendPostRequest("/api/endpoint", requestBody);
    ASSERT_EQ(status_codes::BadRequest, response.status_code());
}

TEST_F (RestAPIEndpointTest, ValidPutRequest) {

    // Create a JSON object for the request body
    web::json::value requestBody;
    requestBody[U("name")] = web::json::value::string(U("John"));
    requestBody[U("age")] = web::json::value::number(25);

    // Send a valid PUT request, currently not implemented
    auto response = sendPutRequest("/api/endpoint", requestBody);
    ASSERT_EQ(status_codes::NotImplemented, response.status_code());
}