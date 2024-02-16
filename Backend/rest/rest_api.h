#pragma once

#include <cpprest/http_listener.h>
#include <cpprest/json.h>
#include <iostream>

using namespace web;
using namespace web::http;
using namespace web::http::experimental::listener;

class RestAPIEndpoint {
public:
    RestAPIEndpoint();
    void listen();

private:
    http_listener listener_;

    void handle_get_request(http_request request);
    void handle_post_request(http_request request);
    void handle_put_request(http_request request);
};

