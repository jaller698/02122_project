#pragma once

// Dependices
#include <map>
#include <string>
#include <vector>
#include <source_location>
#include <string_view>
#include <cpprest/json.h>
#include <cpprest/http_listener.h>
#include <cpprest/http_client.h>
#include <iostream>
#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/exception.h>
#include <cppconn/driver.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <filesystem>
#include <utility>
#include <stdio.h>

// Our headers
#include "logic/calculate_score.h"
#include "logic/logic.h"
#include "data/database_connector.hpp"
#include "data/query_comparison_data.h"
#include "rest/rest_api.h"

/* Written by Christian
 *  Function to get the current time in the format of [YYYY-MM-DD HH:MM:SS]
*/
inline std::string get_time() {
    std::time_t now = std::time(nullptr);
    std::tm* timeinfo = std::localtime(&now);
    char buffer[80];
    std::strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", timeinfo);
    std::string str;
    str.append("[");
    str.append(buffer);
    str.append("] ");
    return str;
}

/* Written by Christian
 *  Function to print debug messages to the console, or a file depending on the context
 *  if this is a release build, it will not print anything
*/
[[maybe_unused]] inline void _debug_print(std::string msg){
#ifdef TEST_ENVIROMENT
    // pipe the output to a file:
    std::ofstream logfile("backend_test.log", std::ios::app);
    if (logfile.is_open()) {
        logfile << get_time() << "DEBUG: " << msg << std::endl;
        logfile.close();
    } else {
        std::cerr << "Failed to open log file" << std::endl;
    }
#elif defined DEBUG
    std::cout << get_time() << "\033[33mDEBUG: \033[0m" << msg << std::endl;
#else
    return;
#endif
}

/* Written by Christian
 * Various logging Macros to make logging easier
*/
#define LOG(msg) std::cout << get_time() << msg << std::endl
#define DEBUG_PRINT(msg) _debug_print(msg);
#define WARNING(msg) std::cout << get_time() << "\033[93mWARNING: \033[0m" << msg << std::endl
#define ERROR(msg, exp) \
        const std::source_location location = std::source_location::current(); \
        std::stringstream error_message; \
        error_message << std::string(msg) << std::string(exp.what()); \
        std::cerr << get_time() << "\033[31mERROR: In file " << location.file_name() << "(" << location.line()  << ':' << location.column() << "): " << location.function_name() << ": " << error_message.str() << "\033[0m" << std::endl;
#define INFO(msg) std::cout << get_time() << "\033[32mINFO: \033[0m" << msg << std::endl
#define CRITICAL(msg) std::cerr << get_time() << "\033[31mCRITICAL: " << msg << "\033[0m"  << std::endl

/* Written by Christian
 * Struct to hold the response from the REST API
*/
struct Response {
    web::http::status_code status;
    web::json::value response;
};

