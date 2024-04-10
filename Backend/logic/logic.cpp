#include "logic.h"

// Define endpoint handlers maps
const std::unordered_map<std::string_view, HandlerFunction> write_handlers = {
    {"/questions", handle_questions_write},
    {"/users", handle_signup},
    {"/userScore", handle_user_score_write},
    {"/comparison", handle_comparison}
};

const std::unordered_map<std::string_view, HandlerFunction> read_handlers = {
    {"/questions", handle_questions_read},
    {"/users", handle_login},
    {"/userScore", handle_user_score_read},
    {"/comparison", handle_comparison}
};

double calculateCarbonScore (std::vector<int> answers)
{
    try {
        //some of the questions in weeks, but we measure in years, so we time them with 52
        DEBUG_PRINT("Calculating carbon score")
        double res=0;
        //Q1
        res+=answers.at(0)*90;
        //Q2
        res+=answers.at(1)*31*52;
        //Q3
        res+=(answers.at(2)*60*7*2.4)*52; //the middle number is incorrect, it is L/km but we dont know it.
        //Q4
        res += (answers.at(3))*60*7*2.4*((100-57.5)/100)*52;
        //Q5
        if(answers.at(4) == 0){
            res += 60*2;
        }else{
            res += 60/(answers.at(4));
        }
        //Q6
        res += answers.at(5)*0;
        DEBUG_PRINT("Got a carbon score of: " + std::to_string(res));
        return res;
    } catch (const std::exception &e) {
        ERROR("Error in calculating carbon score: ", e);
        throw e;
    }
}

// Function which based on the endpoint, sends the data to the correct handler
struct Response handle_data(const std::string &endpoint, web::json::value request_body, bool write_data)
{
    DEBUG_PRINT("Received a request on endpoint: " + endpoint + " with body: " + request_body.serialize());
    const auto& handlers = write_data ? write_handlers : read_handlers;
    auto it = handlers.find(endpoint);
    try {
        if (it != handlers.end()) {
            DEBUG_PRINT("Handling request with handler");
            return it->second(request_body);
        } else {
            WARNING("No suitable endpoint found, looked for: " + endpoint);
            return Response(http::status_codes::NotFound, web::json::value::null());
        }
    } catch (sql::SQLException &e) {
        ERROR("SQL Error in handling data: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    } catch (const std::exception &e) {
        ERROR("Error in handling data: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}

// Handle inserting the filled out questions into the database
// Should return the carbon score, unless a sql exception occurs
struct Response handle_questions_write(const web::json::value &request_body)
{
    try {
            auto title = request_body.at("title").as_string();
            auto userID = request_body.at("userID").as_string();
            web::json::value tmp = request_body.at("answers");
           
            std::vector<std::string> answers;
            answers.push_back(userID);
            auto it = tmp.as_object().begin();
            std::advance(it, 1);
            std::vector<int> ansMath;
            for (auto &answer : tmp.as_object())
            {
                ansMath.push_back(stoi(answer.second.as_string()));
                answers.push_back(answer.second.as_string());
            }
            dataBaseStart db;
            db.insert("InitialSurvey",answers);
            double carbonScore = (double) calculateCarbonScore(ansMath);
            web::json::value response = web::json::value::object();
            response["response"]["carbonScore"] = web::json::value::number(carbonScore);
            DEBUG_PRINT("updating carbon score to: " + std::to_string(carbonScore));
            db.updateUserScore(userID, carbonScore);
            return Response(http::status_codes::Created, response);
    } catch (const std::exception &e) {
        ERROR("Error in handling writing questions: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}

// Handle reading the questions from the database
// and sending them to the users
struct Response handle_questions_read(const web::json::value &request_body)
{
    try {
    dataBaseStart db;
    web::json::value questions = web::json::value::object();
    questions["title"] = web::json::value::string("Questions");
    questions["questions"] = db.get("Questions", "");
    return Response(http::status_codes::OK, questions);
    } catch (const std::exception &e) {
        ERROR("Error in handling reading questions: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}

// Handle signup request
struct Response handle_signup(const web::json::value &request_body)
{
    try {
    if (request_body.at("User").is_null() || request_body.at("Password").is_null())
        return Response(http::status_codes::BadRequest, web::json::value::null());
    
    auto username = request_body.at("User").as_string();
    auto password = request_body.at("Password").as_string();
    auto score = "0";
    std::vector<std::string> userInfo;
    userInfo.push_back(username);
    userInfo.push_back(password);
    userInfo.push_back(score);
    dataBaseStart db;

    // check if user already exists
    if (!db.get("Users", username).has_field("Fail"))
    {
        return Response(http::status_codes::Conflict, web::json::value::null());
    }

    db.insert("Users", userInfo);
    web::json::value response = web::json::value::object();
    response["response"] = web::json::value::string("User created");
    return Response(http::status_codes::Created, response);
    } catch (const std::exception &e) {
        ERROR("Error in handling signup: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}

// Handle login request
struct Response handle_login(const web::json::value &request_body)
{
    try {
        dataBaseStart db;
        std::string Name = request_body.at("User").as_string();
        auto db_response = db.get("Users", Name);

        // compare the two passwords
        struct Response response;
        if (db_response.has_field("Fail"))
        {
            DEBUG_PRINT("User not found");
            response.response = web::json::value::null();
            response.status = web::http::status_codes::Unauthorized;
            return response;
        }
        DEBUG_PRINT("Comparing passwords: " + db_response.at("Pass").serialize() + " with " + request_body.at("Password").serialize());
        if (db_response.at("Pass").as_string() == request_body.at("Password").as_string())
        {
            DEBUG_PRINT("Passwords matched");
            db_response["Response"] = web::json::value::string("User logged in");
            response.response = db_response;
            response.status = web::http::status_codes::OK;
        }
        else
        {
            DEBUG_PRINT("Passwords did not match");
            response.response = web::json::value::null();
            response.status = web::http::status_codes::Unauthorized;
        }
        return response;
    } catch (const std::exception &e) {
        ERROR("Error in handling login: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}

// Handle reading the user score from the database
struct Response handle_user_score_read(const web::json::value &request_body)
{
    try {
        dataBaseStart db;
        auto Name = request_body.at("User").as_string();
        return Response(web::http::status_codes::OK,db.get("Users", Name).at("Score"));
    } catch (const std::exception &e) {
        ERROR("Error in handling reading user score: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}

// Handle updating the user score, should probably not be used
struct Response handle_user_score_write(const web::json::value &request_body)
{
    try {
        auto username = request_body.at("User").as_string();
        auto score = request_body.at("Score").as_integer();
        dataBaseStart db;
        db.updateUserScore(username, score);
        return Response(http::status_codes::OK, web::json::value::string("Score updated"));
    } catch (const std::exception &e) {
        ERROR("Error in handling writing user score: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}


// Handle comparison request
struct Response handle_comparison(const web::json::value &request_body)
{
    try {
    // TODO
    web::json::value comparison = web::json::value::object();
    web::json::array landcodes = request_body.at("landcodes").as_array();
    comparison["data"] = web::json::value::array();
    comparison["data"][0] = web::json::value::number(2000);
    return Response(http::status_codes::NotImplemented, comparison);
    } catch (const std::exception &e) {
        ERROR("Error in handling comparison: ", e);
        return Response(http::status_codes::InternalError, web::json::value::null());
    }
}