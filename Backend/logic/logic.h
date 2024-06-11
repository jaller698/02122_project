#pragma once
#include "../common.h"

using HandlerFunction = std::function<struct Response(const web::json::value&)>;

struct Response handle_data(const std::string& endpoint, web::json::value request_body, bool write_data);
struct Response handle_questions_write(const web::json::value& request_body);
struct Response handle_questions_read(const web::json::value& request_body);
struct Response handle_signup(const web::json::value& request_body);
struct Response handle_login(const web::json::value& request_body);
struct Response handle_user_score_read(const web::json::value& request_body);
struct Response handle_user_score_write(const web::json::value& request_body);
struct Response handle_comparison(const web::json::value& request_body);
struct Response handle_average(const web::json::value& request_body);
struct Response handle_actionTracker(const web::json::value& request_body);
struct Response handle_categories(const web::json::value& request_body);
struct Response handle_history(const web::json::value& request_body);

