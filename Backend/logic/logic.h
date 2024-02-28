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

void insert(string table, string input[2]);
web::json::value handle_data(const std::string& endpoint, web::json::value request_body);
