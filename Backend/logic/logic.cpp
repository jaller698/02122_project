#include "logic.h"

web::json::value handle_data(const std::string& endpoint, web::json::value request_body, bool write_data) {
#ifdef DEBUG
    std::cout << "Received a request on endpoint: " << endpoint << "with body" << request_body.serialize() <<std::endl;
#endif
   if (endpoint == "/questions") {
       // handle questions
       //get question, or return answers

       
        web::json::value questions = web::json::value::object();
        questions["title"] = web::json::value::string("Questions");
        questions["questions"] = web::json::value::object();
        questions["questions"]["question 1"] = web::json::value::string("string");
        questions["questions"]["question 2"] = web::json::value::string("int");
        std::cout << "Returning questions: " << questions.serialize() << std::endl;
        return questions;
   } else if (endpoint == "/users") {
    //create new user, or login existing user.  switch is the write_data bool
       // handle request for either a new user or login
       std::string userID = request_body.at("userID").as_string();     
       std::string password = request_body.at("password").as_string();
       return web::json::value::null();    
   } else if (endpoint == "/userScore") {
        //get the users score, NOT update it, that will be done in the questions segment
       // handle request for a user's score
       web::json::value userScore = web::json::value::object();
       userScore["score"] = web::json::value::number(100);
       return userScore;
   } else if (endpoint == "/comparison") {
    //dont touch this :)... yet
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



using namespace std;


void insert(string table, int input){

    switch (table)
    {
    case "User":
        /* code */
        

        break;
    case "UpdatedSurvey","InitialSurvey":
        /* code */
        statement = connection->createStatement();
        "INSERT INTO "
        statement->execute("INSERT INTO InitialSurvey (Username) VALUES ('Alice')");
        cout << "Data inserted into the table." << endl;
        delete statement;


        break;
    case "GoalsSurvey":
        /* code */
        break;
    case "ComparisonData":
        /* code */
        break;

    default:
        break;
    }

    statement = connection->createStatement();
    string command="INSERT INTO Users (Username) VALUES ('tester')";
    statement->execute(command);
    statement->execute("INSERT INTO Users (Username) VALUES ('Bob')");
    statement->execute("INSERT INTO Users (Username) VALUES ('Charlie')");
    cout << "Data inserted into the table." << endl;
    delete statement;


}



























