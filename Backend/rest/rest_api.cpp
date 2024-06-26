/* Written by Christian
 * Class to handle the REST API, this class is responsible for listening to incoming requests
 * and routing them to the correct handler function in the logic layer
*/

#include "rest_api.h"

// Mark which methods we support
// Using 0.0.0.0 as address to listen on all interfaces
RestAPIEndpoint::RestAPIEndpoint() : listener_("http://0.0.0.0:8080") {
    listener_.support(methods::GET, std::bind(&RestAPIEndpoint::handle_get_request, this, std::placeholders::_1));
    listener_.support(methods::POST, std::bind(&RestAPIEndpoint::handle_post_request, this, std::placeholders::_1));
    listener_.support(methods::PUT, std::bind(&RestAPIEndpoint::handle_put_request, this, std::placeholders::_1));
    listener_.support(methods::HEAD, std::bind(&RestAPIEndpoint::handle_head_request, this, std::placeholders::_1));
}

// Destructor to close the listener
RestAPIEndpoint::~RestAPIEndpoint() {
    listener_.close().wait();
}

/* Start the listener and wait for requests
 * can be started in a seperate thread, which is why we have the atomic bool
 * to gracefully close down the thread
*/
void RestAPIEndpoint::listen(std::atomic<bool>& stop_flag) {
    DEBUG_PRINT("Listening on " + listener_.uri().to_string());
    try {
        listener_
            .open()
            .then([this]() {
                INFO("Server is ready & listening...");
            })
            .wait();
        listener_.open().wait();
        while(!stop_flag.load()){
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
    }
    catch (const std::exception &e) {
        ERROR("We should not have any exceptions here, but got one Error: ", e);
    }
}

/* 
*  The HTTP HEAD method requests the headers 
*  that would be returned if the HEAD request's 
*  URL was instead requested with the HTTP GET method.
*/
void RestAPIEndpoint::handle_head_request(http_request request) {
    if (!is_request_valid(request)) {
        request.reply(status_codes::BadRequest);
        return;
    }
    std::string endpoint = request.relative_uri().to_string();
    DEBUG_PRINT("Received a HEAD request, on endpoint: " + endpoint);

    // Reply with the appropriate headers
    http_response response(status_codes::OK);
    response.headers().add(U("Content-Type"), U("text/plain"));
    response.headers().add(U("Custom-Header"), U("Value"));
    request.reply(response);
}

/* 
*  The HTTP GET method requests a representation of the specified resource.
*  Requests using GET should only be used to request data (they shouldn't include data)
*/
void RestAPIEndpoint::handle_get_request(http_request request) {
    try {
        std::string endpoint = request.relative_uri().to_string();
        DEBUG_PRINT("Received a GET request, on endpoint: " + endpoint);
        auto request_body = request.extract_json().get();
        if (request_body.is_null()) {
            if (endpoint == "/") {
                request.reply(status_codes::OK, U("No data supplied"));
                return;
            } else if (endpoint != "/questions") {
                WARNING("Request does not contain JSON data, returning 400");
                request.reply(status_codes::BadRequest, U("Please provide a body"));
                return;
            }
        }
        struct Response response = handle_data(endpoint, request_body, false);
        auto status_code = response.status;
        if (status_code != status_codes::OK) {
            WARNING("Error in GET: " + status_code);
            request.reply(status_code);
            return;
        }
        json::value response_body = response.response;

        if (!response_body.is_null()){
            DEBUG_PRINT("Sends JSON data: " + response_body.serialize());
        } else {
            DEBUG_PRINT("response is empty");
        }
        request.reply(status_codes::OK, response_body);
    } catch (std::exception &e) {
        ERROR("Error in GET: ", e);
        request.reply(status_codes::InternalError, e.what());
        return;
    } catch (...) {
        CRITICAL("Unregonized error in GET");
        request.reply(status_codes::InternalError);
        return;
    }
}

/*
*  The HTTP PUT request method creates a new resource or replaces a 
*  representation of the target resource with the request payload.
*  PUT does not have any effect if invoked twice on the same resource. 
*/
void RestAPIEndpoint::handle_put_request(http_request request) {
    try {
        auto client_address = request.remote_address();
        // ensure no PUT request is handled twice
        for (const auto &_request : last_requests) {
            if (_request.to_string() == request.to_string()) {
                INFO("Request already handled");
                request.reply(status_codes::NotModified);
                return;
            }
        }
        last_requests.push_back(request);
        if (!is_request_valid(request, true)) {
            request.reply(status_codes::BadRequest);
            return;
        }
        std::string endpoint = request.relative_uri().to_string();
        DEBUG_PRINT("Received a PUT request, on endpoint: " + endpoint);
        auto request_body = request.extract_json().get();
        DEBUG_PRINT("Recieved JSON data: " + request_body.serialize());
        if (request_body.is_null()) {
            request.reply(status_codes::BadRequest);
            return;
        }
        Response response = handle_data(endpoint, request_body, true);
        auto status_code = response.status;
        if (status_code != status_codes::OK) {
            request.reply(status_code);
            return;
        }
        json::value response_body = response.response;
        if (!response_body.is_null())
            DEBUG_PRINT("Sends JSON data: " + response_body.serialize());
        request.reply(status_codes::Created, response_body);
    } catch (const std::exception &e) {
        ERROR("Error in PUT: ", e);
        request.reply(status_codes::InternalError, e.what());
    } catch (...) {
        CRITICAL("Unregonized error in PUT");
        request.reply(status_codes::InternalError);
        return;
    }
}

/*
* The HTTP POST method sends data to the server. 
* The type of the body of the request is indicated by the Content-Type header.
* POST will have side effects if invoked multiple times on the same resource.
*/
void RestAPIEndpoint::handle_post_request(http_request request) {
    try {
        if (!is_request_valid(request, true)) {
            request.reply(status_codes::BadRequest);
            return;
        }

        std::string endpoint = request.relative_uri().to_string();
        // Extract the JSON data from the request body
        DEBUG_PRINT("Received a POST request, on endpoint: " + endpoint);
        auto request_body = request.extract_json().get();
        // Process the JSON data
        if (request_body.is_null()) {
            WARNING("Request does not contain JSON data, returning 400");
            request.reply(status_codes::BadRequest);
            return;
        }
        DEBUG_PRINT("Received JSON data: " + request_body.serialize());
        Response response = handle_data(endpoint, request_body, true);
        auto status_code = response.status;
        if (status_code != status_codes::OK && status_code != status_codes::Created) {
            request.reply(status_code);
            return;
        }
        json::value response_body = response.response;

        if (!response_body.is_null())
            DEBUG_PRINT("Sends JSON data: " + response_body.serialize());
        request.reply(response.status, response_body);
    } catch (std::exception &e) {
            ERROR("Error in POST: ", e);
            request.reply(status_codes::InternalError, e.what());
            return;
    } catch (...) {
        CRITICAL("Unregonized error in POST");
        request.reply(status_codes::InternalError);
        return;
    }
}

bool RestAPIEndpoint::is_request_valid(const http_request &request, bool json_required, bool content_length_required) {
    // Check if the request is valid
    if ((request.headers().content_type().find("json") == std::string::npos) && json_required) {
        WARNING("Request does not contain JSON data");
        request.reply(status_codes::UnsupportedMediaType);
        return false;
    }
    if (request.headers().content_length() == 0 && content_length_required) {
        WARNING("Request does not contain a content length");
        request.reply(status_codes::LengthRequired);
        return false;
    }
    return true;
}


