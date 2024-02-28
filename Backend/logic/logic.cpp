#include "logic.h"


web::json::value handle_data(const std::string& endpoint, web::json::value request_body, bool write_data) {
#ifdef DEBUG
    std::cout << "Received a request on endpoint: " << endpoint << "with body" << request_body.serialize() <<std::endl;
#endif
   if (endpoint == "/questions") {
       // handle questions
       //get question, or return answers
        if(write_data==true){
            //we are writing to the database
            string k[2]=request_body.at("anwsers").as_array();
            //lav funktion til at skrive til databasen, tag inspiration "Database_connecter"
            insert(request_body.at("title").as_string(), k);

        }else{
            //we are reading the questions from the database


        }
        
        //this code needs to be moved
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

//amake funktions for the other database manipulators, delete put get query etc.
//use these in the functions above
void insert(string table, string input[2]){
        sql::mysql::MySQL_Driver *mysql_driver;
        sql::Connection *connection;
        sql::Statement *statement;
        sql::ResultSet *result_set;

        /* Create a connection */
        mysql_driver = sql::mysql::get_mysql_driver_instance();
        connection = mysql_driver->connect("tcp://127.0.0.1:3306", "root", "mypass");

        /* Connect to the MySQL database */
        connection->setSchema("mysql");

    switch (table)
    {
    case "User":
        /* code */
        // set all the variables to the input answers
        

        break;
    case "UpdatedSurvey":
        /* code */

        break;
    case "InitialSurvey":
        /* code */
        statement = connection->createStatement();
        statement->execute("INSERT INTO " +table + " VALUES ('" + input[0] + "', '" + input[1] + "')");
        cout << "first and second inserted into table" << endl;




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


}



























