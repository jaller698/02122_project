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
        cout << "Table 'Users' created successfully." << endl;
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

        cout << "Table 'InitialSurvey' created successfully." << endl;
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

        cout << "Table 'GoalsSurvey' created successfully." << endl;
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

        cout << "Table 'UpdatedSurvey' created successfully." << endl;
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS ComparisonData (\
                ComparisonType VARCHAR(50) PRIMARY KEY,\
                AnswerQ1 INT,\
                AnswerQ2 INT,\
                AnswerQ3 INT,\
                AnswerQ4 INT,\
                AnswerQ5 INT,\
                AnswerQ6 INT,\
            );");

        cout << "Table 'ComparisonData' created successfully." << endl;
        delete statement;

        std::vector<std::string> tmp ={"Alice", "2","3","4","5","6","7"};
        insert("InitialSurvey", tmp);


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
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
    }
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
    }

    if (table == "UpdatedSurvey")
    {
        /* code */
        // set all the variables to the input answers
    }

    if (table == "InitialSurvey")
    {
        int tableSize = 6;
        if (input.size() != 7)
        {
            cout << "Error: input size is not 7" << endl;
            return;
        }
        std::string inputStr = "INSERT INTO " + table + " VALUES('" + input[0] + "'";
        for (int i = 1; i <= tableSize; i++)
        {
            inputStr += ", " + input[i];
        }
        inputStr += ")";
        std::cout << inputStr << std::endl;
        // " VALUES ('" + input[0] + "', '" + input[1] + "', '" + input[2] + "', '" + input[3] + "', '" + input[4]+ "', '" + input[5]+ "', '" + input[6]+ "')";
        cout << inputStr;
        statement = connection->createStatement();
        statement->execute(inputStr);
    }

    if (table == "GoalsSurvey")
    {
        /* code */
        // set all the variables to the input answers
        std::string inputStr = "INSERT INTO " + table + " VALUES ('Alice', " + input[0] + ", " + (input[1]) + ", " + (input[2]) + ", " + (input[3]) + ", " + (input[4])+ ", " + (input[5]) + ")";
        cout << inputStr;
        statement = connection->createStatement();
        statement->execute(inputStr);

    }

    if (table == "ComparisonData")
    {
        /* code */
        // set all the variables to the input answers
    }
}
