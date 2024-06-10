#include "calculate_score.h"

double foodScore=0;
double transportScore=0;
double energyScore=0;
double homeScore=0;
double otherScore=0;

double& findVar(std::string type)
{
    if (type == "food")
    {
        return foodScore;
    }
    else if (type == "transportation")
    {
        return transportScore;
    }
    else if (type == "energy")
    {
        return energyScore;
    }
    else if (type == "home")
    {
        return homeScore;
    }
    else
    {
        return otherScore;
    }
}

double calculateCarbonScore (std::vector<int> &answers, std::string userID)
{
    try {
        dataBaseStart db;

        //some of the questions in weeks, but we measure in years, so we time them with 52
        DEBUG_PRINT("Calculating carbon score")

        web::json::value jsonConfig = web::json::value::object(); 
        std::ifstream f("questions.json");
        std::stringstream strStream;
        strStream << f.rdbuf();
        f.close(); 
        jsonConfig = web::json::value::parse(strStream);
        auto questions = jsonConfig.at("questions").as_array();

        for (size_t i = 0; i < answers.size(); i++)
        {
            DEBUG_PRINT("Answer: " + std::to_string(answers[i]));
            // map from json["type"] to varibale score:
            double& score = findVar(questions[i].at("category").as_string());
            double imd_score = answers[i] * questions[i].at("estimated cost of KG CO2 per unit").as_double();
            if (questions[i].at("unit").as_string() == "weeks" || questions[i].at("unit").as_string() == "times a week")
            {
                imd_score *= 52;
            } 
            else if (questions[i].at("unit").as_string() == "months" || questions[i].at("unit").as_string() == "times a month")
            {
                imd_score *= 12;
            }
            else if (questions[i].at("unit").as_string() == "hours") 
            {
                imd_score *= 12 * 52 * 24;
            }
            else if (questions[i].at("unit").as_string() == "days" || questions[i].at("unit").as_string() == "times a day" ) 
            {
                imd_score *= 365;
            } else if (questions[i].at("unit").as_string() == "years" || questions[i].at("unit").as_string() == "times a year" || questions[i].at("unit").as_string() == "choice")
            {
                // do nothing
            } else {
                WARNING("Unknown unit: " + questions[i].at("unit").as_string());
            }
            score += imd_score;
            DEBUG_PRINT(questions[i].at("category").as_string() + " score: " + std::to_string(score) + " imd_score: " + std::to_string(imd_score));
        }

        double res = foodScore + transportScore + energyScore + homeScore + otherScore;

        db.insertCategorizedScore(userID, res, foodScore, transportScore, energyScore, homeScore, otherScore);

        std::vector<std::string> db_answers;
        db_answers.push_back(userID);
        for(size_t i = 0; i < answers.size(); i++)
        {
            db_answers.push_back(std::to_string(answers[i]));
        }
        db.insert("InitialSurvey",db_answers);
        DEBUG_PRINT("Got a carbon score of: " + std::to_string(res));
        // set all scores back to 0
        foodScore = 0;
        transportScore = 0;
        energyScore = 0;
        homeScore = 0;
        otherScore = 0;
        return res;
    } catch (const std::exception &e) {
        ERROR("Error in calculating carbon score: ", e);
        // set all scores back to 0
        foodScore = 0;
        transportScore = 0;
        energyScore = 0;
        homeScore = 0;
        otherScore = 0;
        throw e;
    }
}

double calculateCarbonScore (const std::vector<std::string> &answers)
{
    std::vector<int> ansMath;
    for(size_t i = 0; i < answers.size(); i++)
    {
        auto answer = answers[i];

        if (is_number(answer))
        {
            DEBUG_PRINT("Converting string to int: " + answer);
            ansMath.push_back(std::stoi(answer));
        } else {
            DEBUG_PRINT("Looking for answer: " + answer); // Maybe there's a better way once, we have more possible answers perhaps an unordered map (hashtable)
            if (answer == "yes") {
                ansMath.push_back(1);
            } else if (answer == "no") {
                ansMath.push_back(0);
            } else if (answer == "true") {
                ansMath.push_back(1);
            } else if (answer == "false") {
                ansMath.push_back(0);
            } else {
                WARNING("Unknown answer: " + answer);
                continue;
            }
        }
    }
    
    return calculateCarbonScore(ansMath, answers[0]);
}