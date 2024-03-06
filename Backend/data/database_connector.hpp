#pragma once


#include <iostream>
#include <mysql_connection.h>
#include <mysql_driver.h>
#include <cppconn/exception.h>
#include <cppconn/driver.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include "logic/logic.h"


class dataBaseStart{
    private:
        sql::mysql::MySQL_Driver *mysql_driver;
        sql::Connection *connection;
        sql::Statement *statement;
        sql::ResultSet *result_set;
    public:
        void insert(std::string table, std::vector<std::string> input);
        void init();


};
