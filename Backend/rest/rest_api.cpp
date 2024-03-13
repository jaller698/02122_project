#include "rest_api.h"

RestAPIEndpoint::RestAPIEndpoint() : listener_("http://0.0.0.0:8080") {
    listener_.support(methods::GET, std::bind(&RestAPIEndpoint::handle_get_request, this, std::placeholders::_1));
    listener_.support(methods::POST, std::bind(&RestAPIEndpoint::handle_post_request, this, std::placeholders::_1));
    listener_.support(methods::PUT, std::bind(&RestAPIEndpoint::handle_put_request, this, std::placeholders::_1));
    listener_.support(methods::HEAD, std::bind(&RestAPIEndpoint::handle_head_request, this, std::placeholders::_1));
}

void RestAPIEndpoint::listen() {
    DEBUG_PRINT("Listening on " + listener_.uri().to_string());
    try {
        listener_
            .open()
            .then([this]() {
                INFO("Server is ready & listening...");
            })
            .wait();
        std::cin.get();
        listener_.close().wait();
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
    //if (!is_request_valid(request)) {
    //    return;
    //}
    std::string endpoint = request.relative_uri().to_string();
    DEBUG_PRINT("Received a GET request, on endpoint: " + endpoint);

    auto request_body = request.extract_json().get();
    if (request_body.is_null() && endpoint == "/") {
        request.reply(status_codes::OK, U("No data supplied"));
        return;
    }
    json::value response_body;
    try {
        response_body = handle_data(endpoint, request_body, false);
        if (response_body.has_field("Fail")){
            request.reply(status_codes::Unauthorized);
            return;
        }
    } catch (std::exception &e) {
        ERROR("Error in GET: ", e);
        request.reply(status_codes::InternalError);
        return;
    }
    DEBUG_PRINT("Sends JSON data: " + response_body.serialize());

    request.reply(status_codes::OK, response_body);
}

/*
*  The HTTP PUT request method creates a new resource or replaces a 
*  representation of the target resource with the request payload.
*  PUT does not have any effect if invoked twice on the same resource. 
*/
void RestAPIEndpoint::handle_put_request(http_request request) {
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

    try {
        request.extract_json().then([=](json::value request_body) {
            DEBUG_PRINT("Recieved JSON data: " + request_body.serialize());
            if (request_body.is_null()) {
                request.reply(status_codes::BadRequest);
                return;
            }
            json::value response_body = handle_data(endpoint, request_body, true);
            DEBUG_PRINT("Sends JSON data: " + response_body.serialize());
            request.reply(status_codes::Created, response_body);
        });
    } catch (const std::exception &e) {
        ERROR("Error in PUT: ", e);
        request.reply(status_codes::InternalError, e.what());
    }
}

/*
* The HTTP POST method sends data to the server. 
* The type of the body of the request is indicated by the Content-Type header.
* POST will have side effects if invoked multiple times on the same resource.
*/
void RestAPIEndpoint::handle_post_request(http_request request) {
    if (!is_request_valid(request, true)) {
        request.reply(status_codes::BadRequest);
        return;
    }

    std::string endpoint = request.relative_uri().to_string();

    // Extract the JSON data from the request body
    DEBUG_PRINT("Received a POST request, on endpoint: " + endpoint);

    request.extract_json().then([=](json::value request_body) {
        // Process the JSON data
        if (request_body.is_null()) {
            request.reply(status_codes::BadRequest);
            return;
        }
        DEBUG_PRINT("Received JSON data: " + request_body.serialize());
        json::value response_body;
        try {
            response_body = handle_data(endpoint, request_body, true);
        } catch (std::exception &e) {
            ERROR("Error in POST: ", e);
            request.reply(status_codes::InternalError, e.what());
            return;
        }
        DEBUG_PRINT("Sends JSON data: " + response_body.serialize());
        request.reply(status_codes::Created, response_body);
    });
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


