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
        statement = connection->createStatement();
        statement->execute("INSERT INTO Users (Username) VALUES('Alice')");
        delete statement;

        /*// call our test insert function
        std::cout << "hello";
        //std::string m[7] = {"Alice", "second", "second", "second", "second", "second", "second"};
        insert("InitialSurvey", m);
        std::vector<std::string> tmp
         ={"2","3","4","5","6","7"};
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
        // TODO make this print prettier
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
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
            questions[output->getString(2)] = web::json::value::string(output->getString(3));
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
