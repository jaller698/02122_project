/* Written by Christian
 * A collection of common functions to send HTTP requests to the server
 * only used for testing purposes, as it assumes the server is running on localhost
*/

#pragma once

#include <memory>
#include <cpprest/http_client.h>
#include <cpprest/json.h>
#include <cpprest/http_msg.h>

// Helper function to send a POST request with JSON data
inline std::unique_ptr<http_response> sendPostRequest(const std::string& endpoint, const web::json::value& jsonBody) {
    web::http::client::http_client client("http://localhost:8080");
    web::http::http_request request(web::http::methods::POST);
    request.set_request_uri(endpoint);
    request.set_body(jsonBody);
    request.headers().set_content_type(U("application/json"));
    http_response response = client.request(request).get();
    return std::make_unique<http_response>(std::move(response));;
}

// Helper function to send a GET request
inline std::unique_ptr<http_response> sendGetRequest(const std::string& endpoint) {
    web::http::client::http_client client("http://localhost:8080");
    web::http::http_request request(web::http::methods::GET);
    request.set_request_uri(endpoint);
    http_response response = client.request(request).get();
    return std::make_unique<http_response>(std::move(response));;
}

// Helper function to send a GET request with JSON data
inline std::unique_ptr<http_response> sendGetRequest(const std::string& endpoint, const web::json::value& jsonBody) {
    web::http::client::http_client client("http://localhost:8080");
    web::http::http_request request(web::http::methods::GET);
    request.set_request_uri(endpoint);
    request.set_body(jsonBody);
    request.headers().set_content_type(U("application/json"));
    http_response response = client.request(request).get();
    return std::make_unique<http_response>(std::move(response));;
}

// Helper function to send a PUT request with JSON data
inline std::unique_ptr<http_response> sendPutRequest(const std::string& endpoint, const web::json::value& jsonBody) {
    web::http::client::http_client client("http://localhost:8080");
    web::http::http_request request(web::http::methods::PUT);
    request.set_request_uri(endpoint);
    request.set_body(jsonBody);
    request.headers().set_content_type(U("application/json"));
    http_response response = client.request(request).get();
    return std::make_unique<http_response>(std::move(response));;
}