#include <cpprest/http_listener.h>
#include <cpprest/json.h>
#include <iostream>

void handle_get_request(web::http::http_request request);
void handle_post_request(web::http::http_request request);
void listen();