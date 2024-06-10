#include "database_connector.hpp"


dataBaseStart::~dataBaseStart()
{
    delete connection;
}

int dataBaseStart::init()
{

    try
    {
        std::vector<std::pair<std::string,std::string>> questions = readQuestions();
        /* Connect to the MySQL database */
        connection->setSchema("mysql");

        /* Create the 'test' database if it doesn't exist */
        statement = connection->createStatement();
        statement->execute("CREATE DATABASE IF NOT EXISTS CarbonFootprint;");
        delete statement;

        /* Connect to the MySQL database */
        connection->setSchema("CarbonFootprint");

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS Users (Username VARCHAR(50) PRIMARY KEY, Password VARCHAR(64), CarbonScore INT)");
        DEBUG_PRINT("Table 'Users' created successfully.");
        delete statement;

        statement = connection->createStatement();
        std::string inputstr = "CREATE TABLE IF NOT EXISTS InitialSurvey(Username VARCHAR(50), ";
        for (auto& question : questions)
        {
            inputstr += "Answer" + question.first + " INT, ";
        }
        inputstr += "FOREIGN KEY(Username) REFERENCES Users(Username));";
        DEBUG_PRINT("SQL Command: " + inputstr);
        statement->execute(inputstr);
        DEBUG_PRINT("Table 'InitialSurvey' created successfully.");
        delete statement;
        statement = connection->createStatement();
        
        inputstr = "CREATE TABLE IF NOT EXISTS GoalsSurvey(Username VARCHAR(50), ";
        for (auto& question : questions)
        {
            inputstr += "Answer" + question.first + " INT, ";
        }
        inputstr += "FOREIGN KEY(Username) REFERENCES Users(Username));";
        DEBUG_PRINT("SQL Command: " + inputstr);
        statement->execute(inputstr);
        DEBUG_PRINT("Table 'GoalsSurvey' created successfully.");

        statement = connection->createStatement();
        inputstr = "CREATE TABLE IF NOT EXISTS UpdatedSurvey(Username VARCHAR(50), SurveyNR INT PRIMARY KEY,";
        for (auto& question : questions)
        {
            inputstr += "Answer" + question.first + " INT, ";
        }
        inputstr += "FOREIGN KEY(Username) REFERENCES Users(Username));";
        DEBUG_PRINT("SQL Command: " + inputstr);
        statement->execute(inputstr);
        delete statement;

        statement = connection->createStatement();
        inputstr = "CREATE TABLE IF NOT EXISTS ActionTrackerData(Username VARCHAR(50), Action VARCHAR(100), Category VARCHAR(100), Date DATETIME, CarbonScoreChanged DOUBLE, FOREIGN KEY(Username) REFERENCES Users(Username));";
        DEBUG_PRINT("SQL Command: " + inputstr);
        statement->execute(inputstr);
        delete statement;

        statement = connection->createStatement();
        inputstr = "CREATE TABLE IF NOT EXISTS CarbonScoreHistory(Username VARCHAR(50), Date DATETIME, CarbonScore DOUBLE, FOREIGN KEY(Username) REFERENCES Users(Username));";
        DEBUG_PRINT("SQL Command: " + inputstr);
        statement->execute(inputstr);
        delete statement;

        statement = connection->createStatement();
        inputstr = "CREATE TABLE IF NOT EXISTS CarbonScore(Username VARCHAR(50), totalScore DOUBLE, foodScore DOUBLE, transportScore DOUBLE, energyScore DOUBLE, homeScore DOUBLE, otherScore DOUBLE, FOREIGN KEY(Username) REFERENCES Users(Username));";
        DEBUG_PRINT("SQL Command: " + inputstr);
        statement->execute(inputstr);
        delete statement;

        statement = connection->createStatement();
        inputstr = "CREATE TABLE IF NOT EXISTS ComparisonData(ComparisonType VARCHAR(50) PRIMARY KEY, ";
        for (auto& question : questions)
        {
            inputstr += "Answer" + question.first + " INT, ";
        }
        inputstr.pop_back();
        inputstr.pop_back();
        inputstr += ");";
        DEBUG_PRINT("SQL Command: " + inputstr);
        statement->execute(inputstr);
        delete statement;

        // check if the table exists, if not create it and populate it
        statement = connection->createStatement();
        inputstr = "SHOW TABLES LIKE 'WorldComparisonData';";
        result_set = statement->executeQuery(inputstr);
        if (result_set->rowsCount() == 0)
        {
            inputstr = "CREATE TABLE IF NOT EXISTS WorldComparisonData(IsoCode VARCHAR(50) PRIMARY KEY, \
                        Country VARCHAR(50), \
                        CarbonScore DOUBLE)";
            DEBUG_PRINT("SQL Command: " + inputstr);
            statement->execute(inputstr);
            auto country_data = query_comparison_data();

            for (const auto& country : country_data)
            {
                std::string name, code, value;
                std::tie(code, name, value) = country;
                inputstr = "INSERT INTO WorldComparisonData VALUES('" + code + "', \"" + name + "\", " + value + ")";
                DEBUG_PRINT("SQL Command: " + inputstr);
                statement->execute(inputstr);
            }
        }

        statement = connection->createStatement();
        statement->execute("CREATE TABLE IF NOT EXISTS Questions(\
                ID VARCHAR(100) PRIMARY KEY,\
                Question VARCHAR(100),\
                Type VARCHAR(100)\
            );");
        DEBUG_PRINT("Table 'Questions' created successfully.");
        delete statement;

        // Create default account for 'guests user', if not already present
        if (
            statement = connection->createStatement(), 
            statement->execute("SELECT * FROM CarbonFootprint.Users WHERE Username='guest'"), 
            result_set = statement->getResultSet(), 
            result_set->next())
        {
            DEBUG_PRINT("Guest user already exists");
        } else {
            DEBUG_PRINT("Creating guest user");
            statement = connection->createStatement();
            statement->execute("INSERT INTO CarbonFootprint.Users (Username,Password,CarbonScore) \
	                            VALUES ('guest','password',-1);");
        }
        updateQuestions();
        return 0; // everything went well
    }
    catch (sql::SQLException &e)
    {
        ERROR("Error in init: ", e);
        return 1; // notfiy main of error
    }
}

web::json::value dataBaseStart::get(std::string table, std::string key){
    sql::ResultSet *output;
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
            User["Pass"] = web::json::value::string(output->getString(2));
            User["Score"] = web::json::value::number(output->getInt(3));
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
            questions[output->getString("ID") + "_" + output->getString("Question")] = web::json::value::string(output->getString("Type"));
        }

        return questions;
    } else {
        std::string command = "SELECT * FROM " + table + " WHERE Username='"+key+"'";
        statement = connection->createStatement();
        statement->execute(command);
    }
    return web::json::value::null();
}

void dataBaseStart::insert(std::string table, std::vector<int> input)
{
    std::vector<std::string> inputStr;
    for (auto &i : input)
    {
        inputStr.push_back(std::to_string(i));
    }
    insert(table, inputStr);
}

void dataBaseStart::insert(std::string table, std::vector<std::string> input)
{
    try {
        connection->setSchema("CarbonFootprint");
        if (table == "Users")
        {
            // set all the variables to the input answers
            statement = connection->createStatement();
            std::string command = "INSERT into " + table + " VALUES('" + input[0] + "', '" + input[1] + "', '" + input[2] + "')";
            DEBUG_PRINT(command);
            statement->execute(command);
            

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
    } catch (sql::SQLException &e) {
        ERROR("Error in insert: ", e);
        throw e;
    }
}

std::string dataBaseStart::createStatement(std::vector<std::string> input, std::string table, size_t tableSize)
{
    if (tableSize == 0) // if value is still it's default update to the size of the questions
        tableSize = readQuestions().size();
    std::string output = "INSERT INTO " + table + " VALUES('" + input[0] + "'";
    if (input.size() != tableSize+1)
    {
        WARNING("input is not the presumed size, expected " + std::to_string(tableSize+1) + " but got " + std::to_string(input.size()) + " elements");
        throw std::logic_error("input is not the presumed size");
    }
    for (size_t i = 1; i <= tableSize; i++)
    {
        output += ", " + input[i];
    }
    output += ")";
    DEBUG_PRINT(output);    
    return output;
}

void dataBaseStart::updateUserScore(std::string username, int score){
    if (username == "guest")
        return;
    updateUserScore(username, (double) score);
}

void dataBaseStart::updateUserScore(std::string username, double score){
    connection->setSchema("CarbonFootprint");
    // set current score to something
    std::string command = "UPDATE Users SET CarbonScore = " + std::to_string(score) + " WHERE Username = '" + username + "'";
    statement = connection->createStatement();
    statement->execute(command);
    delete statement;
    // also update the historic score:
    command = "INSERT INTO CarbonScoreHistory VALUES('" + username + "', NOW(), " + std::to_string(score) + ")";
    statement = connection->createStatement();
    statement->execute(command);
    delete statement;
}

void dataBaseStart::insertAction(std::string username, std::string action, std::string category, double carbonScoreChanged, std::string date)
{
    connection->setSchema("CarbonFootprint");
    std::string command = "INSERT INTO ActionTrackerData VALUES('" + username + "', '" + action + "', '" + category + "', '" + date + "', " + std::to_string(carbonScoreChanged) + ")";
    statement = connection->createStatement();
    statement->execute(command);
    delete statement;
}

double dataBaseStart::getAverage()
{
    connection->setSchema("CarbonFootprint");
    double output = -1;
    statement = connection->createStatement();
    result_set = statement->executeQuery("SELECT AVG(CarbonScore) FROM Users");
    if (result_set->next())
    {
        output = result_set->getDouble(1);
    }
    return output >= 0 ? output : 0;
}

web::json::value dataBaseStart::getComparison(web::json::array landcodes) 
{
    connection->setSchema("CarbonFootprint");
    web::json::value output = web::json::value::array();
    for (auto &landcode : landcodes)
    {
        std::string command = "SELECT * FROM WorldComparisonData WHERE IsoCode = '" + landcode.as_string() + "'";
        DEBUG_PRINT("SQL Command: " + command);
        statement = connection->createStatement();
        result_set = statement->executeQuery(command);
        if (result_set->next())
        {
            DEBUG_PRINT("Found country: " + result_set->getString(2));
            web::json::value country = web::json::value::object();
            country["Country"] = web::json::value::string(result_set->getString(2));
            country["CarbonScore"] = web::json::value::number((double) result_set->getDouble(3));
            output[output.size()] = country;
        }
    }
    return output;

}

void dataBaseStart::insertCategorizedScore(std::string username, double totalScore, double foodScore, double transportScore, double energyScore, double homeScore, double otherScore) 
{
    connection->setSchema("CarbonFootprint");
    statement = connection->createStatement();
    // check if the user already has a score, if so update it
    std::string command = "SELECT * FROM CarbonScore WHERE Username = '" + username + "'";
    result_set = statement->executeQuery(command);
    if (result_set->next())
    {
        command = "UPDATE CarbonScore SET totalScore = " + std::to_string(totalScore) + ", foodScore = " + std::to_string(foodScore) + ", transportScore = " + std::to_string(transportScore) + ", energyScore = " + std::to_string(energyScore) + ", homeScore = " + std::to_string(homeScore) + ", otherScore = " + std::to_string(otherScore) + " WHERE Username = '" + username + "'";
        statement->execute(command);
        delete statement;
        return;
    }
    command = "INSERT INTO CarbonScore VALUES ('" + username + "', " + std::to_string(totalScore) + ", " + std::to_string(foodScore) + ", " + std::to_string(transportScore) + ", " + std::to_string(energyScore) + ", " + std::to_string(homeScore) + ", " + std::to_string(otherScore) + ")";
    statement->execute(command);
    delete statement;
}

web::json::value dataBaseStart::getCategories(std::string username) 
{
    connection->setSchema("CarbonFootprint");
    statement = connection->createStatement();
    std::string command = "SELECT * FROM CarbonScore WHERE Username = '" + username + "'";
    result_set = statement->executeQuery(command);
    web::json::value output = web::json::value::object();
    if (result_set->next())
        {
            output["totalScore"] = web::json::value::number((double) result_set->getDouble(2));
            output["foodScore"] = web::json::value::number((double) result_set->getDouble(3));
            output["transportScore"] = web::json::value::number((double) result_set->getDouble(4));
            output["energyScore"] = web::json::value::number((double) result_set->getDouble(5));
            output["homeScore"] = web::json::value::number((double) result_set->getDouble(6));
            output["otherScore"] = web::json::value::number((double) result_set->getDouble(7));
        }
    return output;
}

std::vector<std::pair<std::string,std::string>> dataBaseStart::readQuestions()
{
    web::json::value questions = web::json::value::object();
    std::vector<std::pair<std::string,std::string>> output;
    try {
        std::ifstream f("questions.json");
        std::stringstream strStream;
        strStream << f.rdbuf();
        f.close(); 
        questions = web::json::value::parse(strStream);
        DEBUG_PRINT(questions.serialize());
        for (auto &question : questions.at("questions").as_array())
        {
            DEBUG_PRINT("Question: " + question.at("question").as_string());
            output.push_back({question.at("id").as_string(), question.at("Type").as_string()});
        }
    } catch (std::exception &e) {
        ERROR("Error in getQuestions: ", e);
    }
    return output;
}

void dataBaseStart::updateQuestions()
{
    try{
        connection->setSchema("CarbonFootprint");

        // Compare the input to the questions in the database
        web::json::value questions;
        try {
            std::ifstream f("questions.json");
            std::stringstream strStream;
            strStream << f.rdbuf();
            f.close(); 
            questions = web::json::value::parse(strStream);
        } catch (std::exception &e) {
            ERROR("Error in updateQuestions: ", e);
        }
        web::json::array inputQuestions = questions.at("questions").as_array();

        for (auto &question : inputQuestions)
        {
            DEBUG_PRINT("Checking question: " + question.at("question").as_string());
            std::string command = "SELECT * FROM Questions WHERE ID = '" + question.at("id").as_string() + "'";
            DEBUG_PRINT("SQL Command: " + command);
            statement = connection->createStatement();
            result_set = statement->executeQuery(command);
            if (result_set->next())
            {
                // Check if the question is the same, if so we don't update not even the type
                std::string result = result_set->getString(2);
                if (result != question.at("question").as_string())
                {
                    DEBUG_PRINT("Updating question: " + question.at("question").as_string());
                    std::string inputStr = "UPDATE Questions SET Question = '" + question.at("question").as_string() + "', Type ='" + question.at("Type").as_string() + "' WHERE ID = '" + question.at("id").as_string() + "'";
                    statement = connection->createStatement();
                    statement->execute(inputStr);
                }
            } else {
                // If there is no question with the same ID, we insert it
                DEBUG_PRINT("Inserting question: " + question.at("question").as_string());
                std::string inputStr = "INSERT INTO Questions VALUES('" + question.at("id").as_string() + "', '" + question.at("question").as_string() + "', '" + question.at("Type").as_string() + "')";
                statement = connection->createStatement();
                statement->execute(inputStr);
            }
        }
    } catch (std::exception &e) {
        ERROR("Error in updateQuestions: ", e);
    }
}

#ifdef DEBUG
void dataBaseStart::reset()
{
    try {
        connection->setSchema("CarbonFootprint");
        statement = connection->createStatement();
        result_set = statement->executeQuery("SHOW TABLES");
        std::vector<std::string> tables;
        while (result_set->next())
        {
            std::string table = result_set->getString(1);
            if (table == "WorldComparisonData")
                continue;
            DEBUG_PRINT("Dropping table: " + table);
            tables.push_back(table);
        }
        delete statement;
        for (auto &table : tables)
        {
            statement = connection->createStatement();
            statement->execute("DROP TABLE " + table);
            delete statement;
        }
        init();
    } catch (sql::SQLException &e) {
        ERROR("Error in reset: ", e);
    }
}
#else
void dataBaseStart::reset()
{
    WARNING("Reset is only allowed in debug mode");
}
#endif



