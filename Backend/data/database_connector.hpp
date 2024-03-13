#pragma once
#include "../common.h"

class dataBaseStart{
    private:
        sql::mysql::MySQL_Driver *mysql_driver;
        sql::Connection *connection;
        sql::Statement *statement;
        sql::ResultSet *result_set;
        std::string createStatement(std::vector<std::string> input, std::string table, int tableSize = 6);
    public:
        void insert(std::string table, std::vector<std::string> input);
        web::json::value get(std::string table, std::string key);
        void init();


};
