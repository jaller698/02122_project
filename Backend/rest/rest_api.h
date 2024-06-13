#pragma once
#include "../common.h"

using namespace web;
using namespace web::http;
using namespace web::http::experimental::listener;

/* Written by Christian
 * Class to handle the REST API, this class is responsible for listening to incoming requests
 * and routing them to the correct handler function in the logic layer
*/
class RestAPIEndpoint {
public:
    ~RestAPIEndpoint();
    RestAPIEndpoint();
    void listen(std::atomic<bool>& stop_flag);

private:
    http_listener listener_;
    std::vector<http_request> last_requests;
    void handle_head_request(http_request request);
    void handle_get_request(http_request request);
    void handle_post_request(http_request request);
    void handle_put_request(http_request request);
    bool is_request_valid(const http_request &request, bool json_required = false, bool content_length_required = false);
};

