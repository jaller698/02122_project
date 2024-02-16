#include "rest_api.h"

RestAPIEndpoint::RestAPIEndpoint() : listener_("http://0.0.0.0:8080") {
    listener_.support(methods::GET, std::bind(&RestAPIEndpoint::handle_get_request, this, std::placeholders::_1));
    listener_.support(methods::POST, std::bind(&RestAPIEndpoint::handle_post_request, this, std::placeholders::_1));
    listener_.support(methods::PUT, std::bind(&RestAPIEndpoint::handle_put_request, this, std::placeholders::_1));
}

void RestAPIEndpoint::listen() {
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

void RestAPIEndpoint::handle_get_request(http_request request) {
    // Send a simple response for GET request
    std::cout << "Received a get request" << std::endl;
    request.reply(status_codes::OK, U("Hello, world!"));
}

void RestAPIEndpoint::handle_put_request(http_request request) {
    // Send a simple response for PUT request
    try {
        std::cout << "Received a put request" << std::endl;
        throw std::runtime_error("Not implemented");
    } catch (const std::exception &e) {
        std::cerr << "Error: " << e.what() << std::endl;
        request.reply(status_codes::NotImplemented, U("Not implemented"));
    }
}

void RestAPIEndpoint::handle_post_request(http_request request) {
    // Extract the JSON data from the request body
    std::cout << "Received a POST request" << std::endl;
    request.extract_json().then([=](json::value request_body) {
        // Process the JSON data
        std::cout << "Received JSON data: " << request_body.serialize() << std::endl;

        // Reply back with the received JSON data
        if (request_body.is_null()) {
            request.reply(status_codes::BadRequest, U("Invalid JSON data"));
            return;
        }
        request.reply(status_codes::OK, request_body);
    });
}
