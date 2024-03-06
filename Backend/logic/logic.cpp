#include "logic.h"

web::json::value handle_data(const std::string &endpoint, web::json::value request_body, bool write_data)
{
#ifdef DEBUG
    std::cout << "Received a request on endpoint: " << endpoint << "with body" << request_body.serialize() << std::endl;
#endif
    if (endpoint == "/questions")
    {
        // handle questions
        // get question, or return answers
        if (write_data == true)
        {
            auto title = request_body.at("title").as_string();
            auto userID = request_body.at("userID").as_string();
            web::json::value tmp = request_body.at("answers");
            std::vector<std::string> answers;
            answers.push_back(userID);
            auto it = tmp.as_object().begin();
            std::advance(it, 1);
            for (auto &answer : tmp.as_object())
            {
                answers.push_back(answer.second.as_string());
            }
            dataBaseStart db;
            db.insert("InitialSurvey",answers);
            auto carbonScore = 0;
            web::json::value response = web::json::value::object();
            response["response"]["carbonScore"] = web::json::value::number(carbonScore);
            return response;
        }
        else
        {
            //TODO: This needs to be updated dynamically
            web::json::value questions = web::json::value::object();
            questions["title"] = web::json::value::string("Questions");
            questions["questions"]["question 1"] = web::json::value::string("int");
            questions["questions"]["question 2"] = web::json::value::string("int");
            questions["questions"]["question 3"] = web::json::value::string("int");
            questions["questions"]["question 4"] = web::json::value::string("int");
            questions["questions"]["question 5"] = web::json::value::string("int");
            questions["questions"]["question 6"] = web::json::value::string("int");
            std::cout << "Returning questions: " << questions.serialize() << std::endl;
            return questions;
        }
    }
    else if (endpoint == "/users")
    {
        // create new user, or login existing user.  switch is the write_data bool
        //  handle request for either a new user or login
        std::string userID = request_body.at("userID").as_string();
        std::string password = request_body.at("password").as_string();
        return web::json::value::null();
    }
    else if (endpoint == "/userScore")
    {
        // get the users score, NOT update it, that will be done in the questions segment
        // handle request for a user's score
        web::json::value userScore = web::json::value::object();
        userScore["score"] = web::json::value::number(100);
        return userScore;
    }
    else if (endpoint == "/comparison")
    {
        // dont touch this :)... yet
        //  handle comparison request
        web::json::value comparison = web::json::value::object();
        web::json::array landcodes = request_body.at("landcodes").as_array();
        // do some sql stuff
        comparison["data"] = web::json::value::array();
        comparison["data"][0] = web::json::value::number(2000);
        return comparison;
    }
    return web::json::value::null();
}

// amake funktions for the other database manipulators, delete put get query etc.
// use these in the functions above
