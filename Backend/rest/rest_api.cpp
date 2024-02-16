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
        return;
    }
    
    std::string endpoint = request.relative_uri().to_string();
#ifdef DEBUG
    std::cout << "\033[33mDEBUG:\033[0m Received a GET request, on endpoint: " << endpoint << std::endl;
#endif
    request.reply(status_codes::OK, U("Hello, world!"));
}

/*
*  The HTTP PUT request method creates a new resource or replaces a 
*  representation of the target resource with the request payload.
*  PUT does not have any effect if invoked twice on the same resource. 
*/
void RestAPIEndpoint::handle_put_request(http_request request) {
    if (!is_request_valid(request, true)) {
        return;
    }

    std::string endpoint = request.relative_uri().to_string();


    try {
#ifdef DEBUG
        std::cout << "\033[33mDEBUG:\033[0m Received a PUT request, on endpoint: " << endpoint << std::endl;
#endif
        throw std::runtime_error("Not implemented");
    } catch (const std::exception &e) {
        std::cerr << "Error: " << e.what() << std::endl;
        request.reply(status_codes::NotImplemented);
    }
}

/*
* The HTTP POST method sends data to the server. 
* The type of the body of the request is indicated by the Content-Type header.
* POST will have side effects if invoked multiple times on the same resource.
*/
void RestAPIEndpoint::handle_post_request(http_request request) {
    if (!is_request_valid(request, true)) {
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
        request.reply(status_codes::OK, request_body);
    });
}

bool RestAPIEndpoint::is_request_valid(const http_request &request, bool json_required, bool content_length_required) {
    // Check if the request is valid
    if (request.headers().content_type() != U("application/json") && json_required) {
        request.reply(status_codes::UnsupportedMediaType);
        return false;
    }
    if (request.headers().content_length() == 0 && content_length_required) {
        request.reply(status_codes::LengthRequired);
        return false;
    }
    return true;
}


