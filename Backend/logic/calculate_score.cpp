#include "calculate_score.h"

double calculateCarbonScore (std::vector<int> &answers, std::string userID)
{
    try {
        dataBaseStart db;

        //some of the questions in weeks, but we measure in years, so we time them with 52
        DEBUG_PRINT("Calculating carbon score")
        double res=0;
        //Q1
        res+=answers.at(0)*90;
        //Q2
        res+=answers.at(1)*31*52;
        //Q3
        res+=(answers.at(2)*60*7*2.4)*52; //the middle number is incorrect, it is L/km but we dont know it.
        //Q4
        res += (answers.at(3))*60*7*2.4*((100-57.5)/100)*52;
        //Q5
        if(answers.at(4) == 0){
            res += 60*2;
        }else{
            res += 60/(answers.at(4));
        }
        //Q6
        res += answers.at(5)*0;
        std::vector<std::string> db_answers;
        db_answers.push_back(userID);
        for(int i = 0; i < answers.size(); i++)
        {
            db_answers.push_back(std::to_string(answers[i]));
        }
        db.insert("InitialSurvey",db_answers);
        DEBUG_PRINT("Got a carbon score of: " + std::to_string(res));
        return res;
    } catch (const std::exception &e) {
        ERROR("Error in calculating carbon score: ", e);
        throw e;
    }
}

double calculateCarbonScore (const std::vector<std::string> &answers)
{
    double score = 0;
    std::vector<int> ansMath;
    for(int i = 0; i < answers.size(); i++)
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