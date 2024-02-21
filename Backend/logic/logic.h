#include <map>
#include <string>
#include <vector>
#include <cpprest/json.h>
#include <cpprest/http_listener.h>


web::json::value handle_data(const std::string& endpoint, web::json::value request_body);