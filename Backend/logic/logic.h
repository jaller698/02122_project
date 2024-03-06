#include <map>
#include <string>
#include <vector>
#include <cpprest/json.h>
#include <cpprest/http_listener.h>
#include <iostream>
#include "../data/database_connector.hpp"


web::json::value handle_data(const std::string& endpoint, web::json::value request_body, bool write_data);
