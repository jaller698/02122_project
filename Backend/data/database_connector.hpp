#pragma once
#include "../common.h"

/* Written by Christian
 * Class to handle database connection, this class is responsible for connecting to the database
 * and executing queries to read and write data   
*/
class dataBaseStart{
    private:
        sql::mysql::MySQL_Driver *mysql_driver = sql::mysql::get_mysql_driver_instance();
        sql::Connection *connection = mysql_driver->connect("tcp://127.0.0.1:3306", "root", "mypass"); //credentials to connect to the database
        sql::Statement *statement;
        sql::ResultSet *result_set;
        std::string createStatement(std::vector<std::string> input, std::string table, size_t tableSize = 0);
        std::vector<std::pair<std::string,std::string>> readQuestions();
        void updateQuestions();
    public:
        void insert(std::string table, std::vector<int> input);
        void insert(std::string table, std::vector<std::string> input);
        web::json::value get(std::string table, std::string key);
        void updateUserScore(std::string username, int score);
        void updateUserScore(std::string username, double score);
        void insertAction(std::string username, std::string action, std::string category, double carbonScoreChanged, std::string date);
        web::json::value getAction(std::string username);
        void insertCategorizedScore(std::string username, double totalScore, double foodScore, double transportScore, double energyScore, double homeScore, double otherScore);
        int init();
        void reset();
        double getAverage();
        web::json::value getComparison(web::json::array landcodes);
        web::json::value getCategories(std::string username);
        web::json::value getHistory(std::string username);
        ~dataBaseStart();


};

