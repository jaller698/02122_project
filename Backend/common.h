#pragma once

// Dependices 
#include <map>
#include <string>
#include <vector>
#include <cpprest/json.h>
#include <cpprest/http_listener.h>
#include <iostream>
#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/exception.h>
#include <cppconn/driver.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>

// Our headers
#include "logic/logic.h"
#include "data/database_connector.hpp"
#include "rest/rest_api.h"

// Logging
[[maybe_unused]] inline void _debug_print(std::string msg){
#ifdef DEBUG
    std::cout << "\033[33mDEBUG: \033[0m" << msg << std::endl;
#endif
}

#define LOG(msg) std::cout << msg << std::endl
#define DEBUG_PRINT(msg) _debug_print(msg);
#define WARNING(msg) std::cout << "\033[93mWARNING: \033[0m" << msg << std::endl
#define ERROR(msg, exp) \
        std::stringstream error_message; \
        error_message << std::string(msg) << std::string(exp.what()); \
        std::cerr << "\033[31mERROR: " << error_message.str() << "\033[0m" << std::endl;
#define INFO(msg) std::cout << "\033[32mINFO: \033[0m" << msg << std::endl
