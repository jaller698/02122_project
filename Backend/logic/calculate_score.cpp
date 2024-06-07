#include "calculate_score.h"

double calculateCarbonScore (std::vector<int> &answers, std::string userID)
{
    try {
        dataBaseStart db;

        //some of the questions in weeks, but we measure in years, so we time them with 52
        DEBUG_PRINT("Calculating carbon score")
        double foodScore=0;
        double transportScore=0;
        double energyScore=0;
        double homeScore=0;
        double otherScore=0;

        // TODO: The following calculations are not valid, please find correct numbers and adjust
        // Q1: How much time do you spend on airplanes, on average, per year?(In hours)
        transportScore += answers[0] * 53.04; // 53.04 kg CO2 per hour

        // Q2: How many times a week do you eat beef?
        foodScore += answers[1] * 2.6; // 2.6 kg CO2 per meal

        // Q3: How much do you drive per week? (hours)
        transportScore += answers[2] * 0.2; // 0.2 kg CO2 per hour

        // Q4: How much do you take public transportation per week?
        transportScore += answers[3] * 0.1; // 0.1 kg CO2 per hour

        // Q5: How long do you usually keep a new phone?(In years)
        otherScore += answers[4] * 16; // 16 kg CO2 per phone

        // Q6: How many times a week do you shower
        homeScore += answers[5] * 0.5; // 0.5 kg CO2 per shower

        // Q7: Do you turn off lights when you leave a room? (1: always, 2: sometimes 3: never)
        homeScore += answers[6] * 0.1; // 0.1 kg CO2 per hour

        // Q8: Do you bring your own bags when shopping(1: yes, 2:no)
        otherScore += answers[7] * 0.1; // 0.1 kg CO2 per bag

        // Q9: How many times do you promt an AI pr day
        otherScore += answers[8] * 0.1; // 0.1 kg CO2 per prompt

        double res = foodScore + transportScore + energyScore + homeScore + otherScore;
        
        db.insertCategorizedScore(userID, res, foodScore, transportScore, energyScore, homeScore, otherScore);

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