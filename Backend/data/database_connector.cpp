#include "database_connector.hpp"


using namespace std;

void dataBaseStart::init()
{

    try
    {
        sql::mysql::MySQL_Driver *mysql_driver;
        sql::Connection *connection;
        sql::Statement *statement;
        sql::ResultSet *result_set;

        /* Create a connection */
        mysql_driver = sql::mysql::get_mysql_driver_instance();
        connection = mysql_driver->connect("tcp://127.0.0.1:3306", "root", "mypass");

        /* Connect to the MySQL database */
        connection->setSchema("mysql");

        /* Create the 'test' database if it doesn't exist */
        statement = connection->createStatement();
        statement->execute("CREATE DATABASE IF NOT EXISTS CarbonFootprint;");
        delete statement;

        /* Connect to the MySQL database */
        connection->setSchema("CarbonFootprint");

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS Users (Username VARCHAR(50) PRIMARY KEY, Password VARCHAR(50))");
        DEBUG_PRINT("Table 'Users' created successfully.");
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS InitialSurvey(Username VARCHAR(30), \
            AnswerQ1 INT,\
            AnswerQ2 INT,\
            AnswerQ3 INT,\
            AnswerQ4 INT,\
            AnswerQ5 INT,\
            AnswerQ6 INT,\
            FOREIGN KEY(Username) REFERENCES Users(Username));");
        DEBUG_PRINT("Table 'InitialSurvey' created successfully.");
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS GoalsSurvey(\
                Username VARCHAR(30),\
                AnswerQ1 INT,\
                AnswerQ2 INT,\
                AnswerQ3 INT,\
                AnswerQ4 INT,\
                AnswerQ5 INT,\
                AnswerQ6 INT,\
                FOREIGN KEY(Username) REFERENCES Users(Username)\
            );");
        DEBUG_PRINT("Table 'GoalsSurvey' created successfully.");
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS UpdatedSurvey(\
                Username VARCHAR(30),\
                SurveyNR INT PRIMARY KEY,\
                AnswerQ1 INT,\
                AnswerQ2 INT,\
                AnswerQ3 INT,\
                AnswerQ4 INT,\
                AnswerQ5 INT,\
                AnswerQ6 INT,\
                FOREIGN KEY(Username) REFERENCES Users(Username)\
            );");
        DEBUG_PRINT("Table 'UpdatedSurvey' created successfully.");
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS ComparisonData (\
                ComparisonType VARCHAR(50) PRIMARY KEY,\
                AnswerQ1 INT,\
                AnswerQ2 INT,\
                AnswerQ3 INT,\
                AnswerQ4 INT,\
                AnswerQ5 INT,\
                AnswerQ6 INT\
            );");
        DEBUG_PRINT("Table 'ComparisonData' created successfully.");
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS Questions(\
                ID VARCHAR(100) PRIMARY KEY,\
                Question VARCHAR(100),\
                Type VARCHAR(100)\
            );");
        DEBUG_PRINT("Table 'Questions' created successfully.");
        delete statement;

        updateQuestions();
        
    }
    catch (sql::SQLException &e)
    {
        ERROR("Error in init: ", e);
    }
}

web::json::value dataBaseStart::get(std::string table, std::string key){
    mysql_driver = sql::mysql::get_mysql_driver_instance();
    sql::ResultSet *output;
    connection = mysql_driver->connect("tcp://127.0.0.1:3306", "root", "mypass");
    connection->setSchema("CarbonFootprint");
    
 if (table == "Users")
    {
        web::json::value User = web::json::value::object();
        /* code */
        // set all the variables to the input answers
        std::string command = "SELECT * FROM " + table + " WHERE Username='"+key+"'";
        statement = connection->createStatement();
        output = statement->executeQuery(command);
       

        if (output->next()) {
            User["User"] = web::json::value::string(output->getString(1));
            // User["Pass"] = web::json::value::string(output->getString(2));
            // User["Score"] = web::json::value::string(output->getString(3));
        }else{
            User["Fail"] = web::json::value::string("User does not exists");
        }
       
        return User;

    } else if (table == "UpdatedSurvey") {
        // std::string command = "SELECT * FROM " + table + " WHERE Username='"+key+"'";
        // statement = connection->createStatement();
        // statement->execute(command);
    } else if(table=="Questions"){
        std::string command = "SELECT * FROM " + table;

        statement = connection->createStatement();
        output = statement->executeQuery(command);
        web::json::value questions = web::json::value::object();
        while (output->next()) {
            questions[output->getString("Question")] = web::json::value::string(output->getString("Type"));
        }

        return questions;

    }else {
        std::string command = "SELECT * FROM " + table + " WHERE Username='"+key+"'";
        statement = connection->createStatement();
        statement->execute(command);
    }
    return web::json::value::null();
}

void dataBaseStart::insert(std::string table, std::vector<std::string> input)
{
    mysql_driver = sql::mysql::get_mysql_driver_instance();
    connection = mysql_driver->connect("tcp://127.0.0.1:3306", "root", "mypass");
    connection->setSchema("CarbonFootprint");

    if (table == "Users")
    {
        /* code */
        // set all the variables to the input answers
        //UPDATE THIS FOR WHEN WE IMPLEMENT PASSWORDS/CARBONSCORE
        statement = connection->createStatement();
        statement->execute("INSERT INTO Users (Username) VALUES('"+input[0] +"')");
        

    } else if (table == "UpdatedSurvey") {
        std::string inputStr = createStatement(input, table, 7);
        statement = connection->createStatement();
        statement->execute(inputStr);
    } else {
        //we dont need to say tablesize, since its 6 by default
        std::string inputStr = createStatement(input, table);
        statement = connection->createStatement();
        statement->execute(inputStr);
    }
    delete statement;
}

std::string dataBaseStart::createStatement(std::vector<std::string> input, std::string table, int tableSize)
{
    std::string output = "INSERT INTO " + table + " VALUES('" + input[0] + "'";
    if (input.size() != tableSize+1)
    {
        WARNING("input is not the presumed size");
    }
    for (int i = 1; i <= tableSize; i++)
    {
        output += ", " + input[i];
    }
    output += ")";
    DEBUG_PRINT(output);    
    return output;
}


web::json::value dataBaseStart::readQuestions(){
    web::json::value questions = web::json::value::object();
    try {
        std::ifstream f("questions.json");
        std::stringstream strStream;
        strStream << f.rdbuf();
        f.close(); 
        questions = web::json::value::parse(strStream);
        DEBUG_PRINT(questions.serialize());
        return questions;

    } catch (std::exception &e) {
        ERROR("Error in getQuestions: ", e);
    }
}

void dataBaseStart::updateQuestions()
{
    try{
        mysql_driver = sql::mysql::get_mysql_driver_instance();
        connection = mysql_driver->connect("tcp://127.0.0.1:3306", "root", "mypass");
        connection->setSchema("CarbonFootprint");

        // Compare the input to the questions in the database
        web::json::value questions = readQuestions();
        web::json::array inputQuestions = questions.at("questions").as_array();

        for (auto &question : inputQuestions)
        {
            DEBUG_PRINT("Checking question: " + question.at("question").as_string());
            std::string command = "SELECT * FROM Questions WHERE ID = '" + question.at("id").as_string() + "'";
            DEBUG_PRINT("SQL Command: " + command);
            statement = connection->createStatement();
            result_set = statement->executeQuery(command);
            if (result_set->next())
            {
                // Check if the question is the same, if so we don't update not even the type
                std::string result = result_set->getString(2);
                if (result != question.at("question").as_string())
                {
                    DEBUG_PRINT("Updating question: " + question.at("question").as_string());
                    std::string inputStr = "UPDATE Questions SET Question = '" + question.at("question").as_string() + "', Type ='" + question.at("Type").as_string() + "' WHERE ID = '" + question.at("id").as_string() + "'";
                    statement = connection->createStatement();
                    statement->execute(inputStr);
                }
            } else {
                // If there is no question with the same ID, we insert it
                DEBUG_PRINT("Inserting question: " + question.at("question").as_string());
                std::string inputStr = "INSERT INTO Questions VALUES('" + question.at("id").as_string() + "', '" + question.at("question").as_string() + "', '" + question.at("Type").as_string() + "')";
                statement = connection->createStatement();
                statement->execute(inputStr);
            }
        }
    } catch (std::exception &e) {
        ERROR("Error in updateQuestions: ", e);
    }
}
