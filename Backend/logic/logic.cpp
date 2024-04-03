#include "logic.h"

int calculateCarbonScore (std::vector<int> answers)
{
    //some of the questions in weeks, but we measure in years, so we time them with 52
    int res=0;
    //Q1
    res=res+answers[0]*90;
    //Q2
    res=res+answers[1]*31*52;
    //Q3
    res=res+(answers[2]*60*7*2.4)*52; //the middle number is incorrect, it is L/km but we dont know it.
    //Q4
    res=res+answers[3]*60*7*2.4*((100-57.5)/100)*52;
    //Q5
    if(answers[4]==0){
        res=res+60*2;
    }else{
        res=res+60/answers[4];
    }
    //Q6
    res=res+answers[5]*0;
    return res;
}

web::json::value handle_data(const std::string &endpoint, web::json::value request_body, bool write_data)
{
DEBUG_PRINT("Received a request on endpoint: " + endpoint + " with body: " + request_body.serialize());
    try {
        if (endpoint == "/questions")
        {
            if(write_data == true){
            auto title = request_body.at("title").as_string();
            auto userID = request_body.at("userID").as_string();
            web::json::value tmp = request_body.at("answers");
           
            std::vector<std::string> answers;
            answers.push_back(userID);
            auto it = tmp.as_object().begin();
            std::advance(it, 1);
            //Det er lige nu lavet til at spørgsmålene altid returnere Ints, hvis noget ændres skal dette omskrives.
            std::vector<int> ansMath;
            for (auto &answer : tmp.as_object())
            {
                ansMath.push_back(answer.second.as_integer());
                answers.push_back(answer.second.as_string());

            }
            dataBaseStart db;
            db.insert("InitialSurvey",answers);
            //automate this
            //if this does not work, outcomment line below, and make it 0 instead.
            int carbonScore = calculateCarbonScore(ansMath);
            web::json::value response = web::json::value::object();
            response["response"]["carbonScore"] = web::json::value::number(carbonScore);
            return response;
            }else{
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
                DEBUG_PRINT("Getting USER from data: " + request_body.serialize());
                dataBaseStart db;
                std::string Name = request_body.at("User").as_string();
                auto response = db.get("Users",Name);
                
                // compare the two passwords
                DEBUG_PRINT("Comparing passwords: " + response.at("Pass").serialize() + " with " + request_body.at("Password").serialize());
                if (response.at("Pass").as_string() == request_body.at("Password").as_string())
                {
                    response["Response"] = web::json::value::string("User logged in");
                }
                else
                {
                    response["Fail"] = web::json::value::string("User not logged in");
                }

                DEBUG_PRINT("Sending USER data: " + response.serialize());
                return response;


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
                throw std::logic_error("Cannot update user score here");
            } else {

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
        WARNING("no suitable endpoint found");
    } catch (sql::SQLException &e) {
        ERROR("SQL Error in handling data: ", e);
        throw e;
    } catch (const std::exception &e) {
        ERROR("Error in handling data: ", e);
        throw e;
    }
    return web::json::value::null();
}

// amake funktions for the other database manipulators, delete put get query etc.
// use these in the functions above
