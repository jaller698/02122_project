#pragma once
#include "../common.h"


web::json::value handle_data(const std::string& endpoint, web::json::value request_body, bool write_data);

