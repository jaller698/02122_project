#pragma once
#include "../common.h"

class dataBaseStart{
    private:
        sql::mysql::MySQL_Driver *mysql_driver = sql::mysql::get_mysql_driver_instance();
        sql::Connection *connection = mysql_driver->connect("tcp://127.0.0.1:3306", "root", "mypass");
        sql::Statement *statement;
        sql::ResultSet *result_set;
        std::string createStatement(std::vector<std::string> input, std::string table, int tableSize = 6);
        web::json::value readQuestions();
        void updateQuestions();
    public:
        void insert(std::string table, std::vector<std::string> input);
        web::json::value get(std::string table, std::string key);
        void updateUserScore(std::string username, int score);
        void init();


};

