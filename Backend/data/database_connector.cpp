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

        /*std::vector<std::string> tmp ={"Alice", "2","3","4","5", "6","7"};
        insert("InitialSurvey", tmp);
        insert("GoalsSurvey", tmp);
        
        std::vector<std::string> ComparisonData ={"Danish", "2","3","4","5", "6","7"};
        insert("ComparisonData", ComparisonData);

        std::vector<std::string> tmp2 ={"Alice", "66", "2","3","4","5", "6","7"};
        insert("UpdatedSurvey", tmp2);
        */



        /*// call our test insert function
        std::cout << "hello";
        //std::string m[7] = {"Alice", "second", "second", "second", "second", "second", "second"};
        insert("InitialSurvey", m);
        std::vector<std::string> tmp ={"2","3","4","5","6","7"};
        insert("GoalsSurvey", tmp);

        statement = connection->createStatement();
        result_set = statement->executeQuery("SELECT * FROM InitialSurvey");

        // try to print it from here this doesnt print what it should
        cout << "Checking if we just put stuff into the database" << endl;
        // while (result_set->next()) {
        //     cout << "stuff: " << result_set->getString() << endl;
        // }

        delete result_set; */
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
    
 if (table == "User")
    {
        /* code */
        // set all the variables to the input answers
        std::string command = "SELECT * FROM " + table + " WHERE Username='"+key+"'";
        statement = connection->createStatement();
        statement->execute(command);

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

    if (table == "User")
    {
        /* code */
        // set all the variables to the input answers
    } else if (table == "UpdatedSurvey") {
        std::string inputStr = createStatement(input, table, 7);
        statement = connection->createStatement();
        statement->execute(inputStr);
    } else {
        std::string inputStr = createStatement(input, table);
        statement = connection->createStatement();
        statement->execute(inputStr);
    }
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
