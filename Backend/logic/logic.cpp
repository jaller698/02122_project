#include "logic.h"

web::json::value handle_data(const std::string& endpoint, web::json::value request_body) {
#ifdef DEBUG
    std::cout << "Received a request on endpoint: " << endpoint << "with body" << request_body.serialize() <<std::endl;
#endif
   if (endpoint == "/questions") {
       // handle questions
        web::json::value questions = web::json::value::object();
        questions["pageTitle"] = web::json::value::string("Questions");
        questions["questions"]["question 1"] = web::json::value::string("string");
        questions["questions"]["question 2"] = web::json::value::string("int");
        std::cout << "Returning questions: " << questions.serialize() << std::endl;
        return questions;
   } else if (endpoint == "/users") {
       // handle request for either a new user or login
       std::string userID = request_body.at("userID").as_string();     
       std::string password = request_body.at("password").as_string();
       return web::json::value::null();    
   } else if (endpoint == "/userScore") {
       // handle request for a user's score
       web::json::value userScore = web::json::value::object();
       userScore["score"] = web::json::value::number(100);
       return userScore;
   } else if (endpoint == "/comparison") {
      // handle comparison request
      web::json::value comparison = web::json::value::object();
      web::json::array landcodes = request_body.at("landcodes").as_array();
      // do some sql stuff
      comparison["data"] = web::json::value::array();
      comparison["data"][0] = web::json::value::number(2000);
      return comparison;   
   }
   return web::json::value::null();
}
