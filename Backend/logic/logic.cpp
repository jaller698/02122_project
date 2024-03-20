#include "logic.h"

web::json::value handle_data(const std::string &endpoint, web::json::value request_body, bool write_data)
{
DEBUG_PRINT("Received a request on endpoint: " + endpoint + " with body: " + request_body.serialize());

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
            //automate this
            auto carbonScore = 0;
            web::json::value response = web::json::value::object();
            response["response"]["carbonScore"] = web::json::value::number(carbonScore);
            return response;
        }
        else
        {   
            dataBaseStart db;
            web::json::value questions = web::json::value::object();
            questions["title"] = web::json::value::string("Questions");
            questions["questions"] = db.get("Questions","");
            return questions;
        }
    }
    else if (endpoint == "/users")
    {
        if(write_data==true){
            auto UN = request_body.at("User").as_string();
            auto PASS = request_body.at("Password").as_string();
            auto Score = "0";
            std::vector<std::string> userInfo;
            userInfo.push_back(UN);
            userInfo.push_back(PASS);
            userInfo.push_back(Score);
            dataBaseStart db;
            db.insert("Users",userInfo);
            web::json::value response = web::json::value::object();
            response["response"] = web::json::value::string("User created :)");
            return response;
            
        }else{

            dataBaseStart db;
            auto Name = request_body.at("User").as_string();
            return db.get("Users",Name);


        }
        // create new user, or login existing user.  switch is the write_data bool
        //  handle request for either a new user or login
        // std::string userID = request_body.at("userID").as_string();
        // std::string password = request_body.at("password").as_string();
        // return web::json::value::null();
    }
    else if (endpoint == "/userScore")
    {
        if(write_data==true){
            auto UN = request_body.at("User").as_string();
            auto SC = request_body.at("Score").as_string();
            //auto PASS = request_body.at("Password").as_string();
            std::vector<std::string> userInfo;
            userInfo.push_back(UN);
            //userInfo.push_back(PASS);
            dataBaseStart db;
            db.insert("Users",userInfo);
            web::json::value response = web::json::value::object();
            response["response"] = web::json::value::string("User created :)");
            return response;
            
        }else{

            dataBaseStart db;
            auto Name = request_body.at("User").as_string();
            return db.get("Users",Name).at("Score");


        }


        // get the users score, NOT update it, that will be done in the questions segment
        // handle request for a user's score
        
        
        // web::json::value userScore = web::json::value::object();
        // userScore["score"] = web::json::value::number(100);
        // return userScore;
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
