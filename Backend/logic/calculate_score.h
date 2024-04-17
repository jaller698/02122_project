#pragma once

#include "../common.h"

double calculateCarbonScore(const std::vector<std::string> &answers);
double calculateCarbonScore(const std::vector<int> &answers, std::string userID);

// check if string can be converted to int
inline bool is_number(const std::string &s) {
    return 
        !s.empty() && std::find_if(s.begin(), s.end(), [](unsigned char c) 
        { 
            return !std::isdigit(c); 
        }) == s.end();
}