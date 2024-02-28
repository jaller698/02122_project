#include <iostream>
#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/exception.h>
#include <cppconn/driver.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <logic\logic.h>

using namespace std;

void createTableAndShowContents() {
    try {
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
            AnswerQ1 INT,\
            AnswerQ2 INT,\
            AnswerQ3 INT,\
            AnswerQ4 INT,\
            AnswerQ5 INT,\
            AnswerQ6 INT,\
            FOREIGN KEY(Username) REFERENCES Users(Username));"
        );

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
            );"
        );

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
            );"
        );

        cout << "Table 'UpdatedSurvey' created successfully." << endl;
        delete statement;

        statement = connection->createStatement();
        statement->execute("CREATE TABLE CarbonFootprint.ComparisonData(\
                ComparisonType VARCHAR(50) PRIMARY KEY,\
                AnswerQ1 INT,\
                AnswerQ2 INT,\
                AnswerQ3 INT,\
                AnswerQ4 INT,\
                AnswerQ5 INT,\
                AnswerQ6 INT\
            );"
        );

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
        while (result_set->next()) {
            cout << "Name: " << result_set->getString("Username") << endl;
        }

        delete result_set;
        delete statement;
        delete connection;

        //call our test insert function
        logic.insert("InitialSurvey",["first","second"]);

        //try to print it from here
        cout << "Contents of the 'Users' table:" << endl;
        while (result_set->next()) {
            cout << "Name: " << result_set->getString("Username") << endl;
        }

    } catch (sql::SQLException &e) {
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
    }
}
