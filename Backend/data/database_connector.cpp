#include <iostream>
#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/exception.h>
#include <cppconn/driver.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>

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
        statement->execute("CREATE DATABASE IF NOT EXISTS test");
        delete statement;


        /* Connect to the MySQL database */
        connection->setSchema("test");

        /* Create a table */
        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50))");
        cout << "Table 'users' created successfully." << endl;
        delete statement;

        /* Insert some data into the table */
        statement = connection->createStatement();
        statement->execute("INSERT INTO users (name) VALUES ('Alice')");
        statement->execute("INSERT INTO users (name) VALUES ('Bob')");
        statement->execute("INSERT INTO users (name) VALUES ('Charlie')");
        cout << "Data inserted into the table." << endl;
        delete statement;

        /* Retrieve and display contents of the table */
        statement = connection->createStatement();
        result_set = statement->executeQuery("SELECT * FROM users");

        cout << "Contents of the 'users' table:" << endl;
        while (result_set->next()) {
            cout << "ID: " << result_set->getInt("id");
            cout << ", Name: " << result_set->getString("name") << endl;
        }

        delete result_set;
        delete statement;
        delete connection;

    } catch (sql::SQLException &e) {
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
    }
}
