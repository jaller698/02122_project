#include "rest_api.h"

RestAPIEndpoint::RestAPIEndpoint() : listener_("http://0.0.0.0:8080") {
    listener_.support(methods::GET, std::bind(&RestAPIEndpoint::handle_get_request, this, std::placeholders::_1));
    listener_.support(methods::POST, std::bind(&RestAPIEndpoint::handle_post_request, this, std::placeholders::_1));
    listener_.support(methods::PUT, std::bind(&RestAPIEndpoint::handle_put_request, this, std::placeholders::_1));
    listener_.support(methods::HEAD, std::bind(&RestAPIEndpoint::handle_head_request, this, std::placeholders::_1));
}

void RestAPIEndpoint::listen() {
#ifdef DEBUG
    std::cout << "\033[33mDEBUG:\033[0m Listening on " << listener_.uri().to_string() << std::endl;
#endif
    try {
        listener_
            .open()
            .then([this]() {
                std::cout << "Server is listening..." << std::endl;
            })
            .wait();
        std::cin.get();
        listener_.close().wait();
    }
    catch (const std::exception &e) {
        std::cerr << "Error: " << e.what() << std::endl;
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

#ifdef DEBUG
    std::cout << "\033[33mDEBUG:\033[0m Received a HEAD request, on endpoint: " << endpoint << std::endl;
#endif

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
    if (!is_request_valid(request)) {
        request.reply(status_codes::BadRequest);
        return;
    }
    std::string endpoint = request.relative_uri().to_string();

#ifdef DEBUG
    std::cout << "\033[33mDEBUG:\033[0m Received a GET request, on endpoint: " << endpoint << std::endl;
#endif

    auto request_body = request.extract_json().get();
    if (request_body.is_null()) {
        request.reply(status_codes::OK, U("No data supplied"));
        return;
    }
    if (!is_request_valid(request, true)) {
        request.reply(status_codes::BadRequest);
        return;
    }
    json::value response_body;
    try {
        response_body = handle_data(endpoint, request_body);
    } catch (std::exception &e) {
        std::cerr << "Error in GET: " << e.what() << std::endl;
        request.reply(status_codes::NotImplemented);
        return;
    }
#ifdef DEBUG
    std::cout << "Sends JSON data: " << response_body.serialize() << std::endl;
#endif
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
        //std::cout << "Comparing " << _request.to_string() << " with " << request.to_string() << std::endl;
        if (_request.to_string() == request.to_string()) {
            std::cout << "Request already handled" << std::endl;
            request.reply(status_codes::NotModified);
            return;
        }
    }
    std::cout << "Adding request to last_requests" << std::endl;
    last_requests.push_back(request);
    if (!is_request_valid(request, true)) {
        request.reply(status_codes::BadRequest);
        return;
    }
#ifdef DEBUG
        std::cout << "\033[33mDEBUG:\033[0m Received a PUT request, on endpoint: " << endpoint << std::endl;
#endif

    std::string endpoint = request.relative_uri().to_string();

    try {
        request.extract_json().then([=](json::value request_body) {
            std::cout << "Received JSON data: " << request_body.serialize() << std::endl;
            if (request_body.is_null()) {
                request.reply(status_codes::BadRequest);
                return;
            }
            json::value response_body = handle_data(endpoint, request_body);
            std::cout << "Sends JSON data: " << response_body.serialize() << std::endl;
            request.reply(status_codes::OK, response_body);
        });
    } catch (const std::exception &e) {
        std::cerr << "Error in PUT: " << e.what() << std::endl;
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
#ifdef DEBUG
    std::cout << "\033[33mDEBUG:\033[0m Received a POST request, on endpoint: " << endpoint << std::endl;
#endif

    request.extract_json().then([=](json::value request_body) {
        // Process the JSON data
        if (request_body.is_null()) {
            request.reply(status_codes::BadRequest);
            return;
        }
        std::cout << "Received JSON data: " << request_body.serialize() << std::endl;
        json::value response_body;
        try {
            response_body = handle_data(endpoint, request_body);
        } catch (std::exception &e) {
            std::cerr << "Error in POST: " << e.what() << std::endl;
            request.reply(status_codes::InternalError, e.what());
            return;
        }
        std::cout << "Sends JSON data: " << response_body.serialize() << std::endl;
        request.reply(status_codes::OK, response_body);
    });
}

bool RestAPIEndpoint::is_request_valid(const http_request &request, bool json_required, bool content_length_required) {
    // Check if the request is valid
    if ((request.headers().content_type().find("json") == std::string::npos) && json_required) {
        request.reply(status_codes::UnsupportedMediaType);
        return false;
    }
    if (request.headers().content_length() == 0 && content_length_required) {
        request.reply(status_codes::LengthRequired);
        return false;
    }
    return true;
}


