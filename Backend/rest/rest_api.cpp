#include "rest_api.h"

using namespace web;
using namespace web::http;
using namespace web::http::experimental::listener;

void handle_get_request(http_request request) {
    // Send a simple response for GET request
    std::cout << "Received a get request" << std::endl;
    request.reply(status_codes::OK, U("Hello, world!"));
}

void handle_post_request(http_request request) {
    // Extract the JSON data from the request body
    std::cout << "Received a POST request" << std::endl;
    request.extract_json().then([=](json::value request_body) {
        // Process the JSON data
        std::cout << "Received JSON data: " << request_body.serialize() << std::endl;

        // Reply back with the received JSON data
        request.reply(status_codes::OK, request_body);
    });
}

void listen() {
    // Set up HTTP listener
    std::cout << "Setting up HTTP listener...." << std::endl;
    http_listener listener("http://0.0.0.0:8080");
    listener.support(handle_get_request);
    listener.support(methods::POST, handle_post_request);

    try {
        listener
            .open()
            .then([&listener]() {
                std::cout << "Server is listening..." << std::endl;
            })
            .wait();

        std::cout << "Press Enter to exit." << std::endl;
        std::cin.get();
        listener.close().wait();
    }
    catch (const std::exception &e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }
}
