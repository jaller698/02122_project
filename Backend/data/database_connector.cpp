#include "database_connector.hpp"

using namespace std;

void dataBaseStart::createTableAndShowContents()
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

        /* Create a table */
        /*
        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS Users (Username VARCHAR(50), Password VARCHAR(50), PRIMARY KEY(Username))");
        cout << "Table 'Users' created successfully." << endl;
        delete statement;
        */
        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS Users (Username VARCHAR(50) PRIMARY KEY, Password VARCHAR(50))");
        cout << "Table 'Users' created successfully." << endl;
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS InitialSurvey(Username VARCHAR(30), \
            AnswerQ1 VARCHAR(50),\
            AnswerQ2 VARCHAR(50),\
            AnswerQ3 VARCHAR(50),\
            AnswerQ4 VARCHAR(50),\
            AnswerQ5 VARCHAR(50),\
            AnswerQ6 VARCHAR(50),\
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
                AnswerQ1 VARCHAR(50),\
                AnswerQ2 VARCHAR(50),\
                AnswerQ3 VARCHAR(50),\
                AnswerQ4 VARCHAR(50),\
                AnswerQ5 VARCHAR(50),\
                AnswerQ6 VARCHAR(50)\
            );");

        cout << "Table 'ComparisonData' created successfully." << endl;
        delete statement;

        /* Insert some data into the table */
        statement = connection->createStatement();
        statement->execute("INSERT INTO Users (Username) VALUES ('Alice')");
        statement->execute("INSERT INTO Users (Username) VALUES ('Bob')");
        statement->execute("INSERT INTO Users (Username) VALUES ('Charlie')");
        cout << "Data inserted into the table." << endl;
        delete statement;

        /* Retrieve and display contents of the table */
        statement = connection->createStatement();
        result_set = statement->executeQuery("SELECT * FROM Users");

        cout << "Contents of the 'Users' table:" << endl;
        while (result_set->next())
        {
            cout << "Name: " << result_set->getString("Username") << endl;
        }

        // delete result_set;
        delete statement;
        delete connection;

        // call our test insert function
        std::cout << "hello";
        std::string m[7] = {"Alice", "second", "second", "second", "second", "second", "second"};
        //insert("InitialSurvey", m);
        int tmp[] ={2,3,4,5,6,7};
        insert("GoalsSurvey",tmp)

        result_set = statement->executeQuery("SELECT * FROM InitialSurvey");

        // try to print it from here this doesnt print what it should
        cout << "Checking if we just put stuff into the database" << endl;
        // while (result_set->next()) {
        //     cout << "stuff: " << result_set->getString() << endl;
        // }

        delete result_set;
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

void dataBaseStart::insert(std::string table, int input[])
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
        /* code */
        std::string inputStr = "INSERT INTO " + table + " VALUES ('" + input[0] + "', '" + input[1] + "', '" + input[2] + "', '" + input[3] + "', '" + input[4]+ "', '" + input[5]+ "', '" + input[6]+ "')";
        cout << inputStr;
        statement = connection->createStatement();
         cout << "WE MADE IT";
        statement->execute(inputStr);
        std::cout << "first and second inserted into table" << std::endl;
        cout << "yippee";
    }

    if (table == "GoalsSurvey")
    {
        /* code */
        // set all the variables to the input answers
        std::string inputStr = "INSERT INTO " + table + " VALUES ('Alice', " + (input[0]).c_str() + ", " + (input[1]).c_str() + ", " + (input[2]).c_str() + ", " + (input[3]).c_str()+ ", " + (input[4]).c_str()+ ", " + (input[5]).c_str()+ ")";
        cout << inputStr;
        statement = connection->createStatement();
         cout << "WE MADE IT";
        statement->execute(inputStr);
        std::cout << "first and second inserted into table" << std::endl;
        cout << "yippee";
    }

    if (table == "ComparisonData")
    {
        /* code */
        // set all the variables to the input answers
    }
}
