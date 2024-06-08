#include "logic_test.h"

TEST_F(logicTest, QuestionsRead) {
    web::json::value requestBody;

    // Send a valid POST request
    auto response = sendGetRequest("/questions", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    // Assert that the response has size greater than 0
    web::json::value responseJson = response->extract_json().get();
    ASSERT_GT(responseJson.size(), 0);

    // Assert that the response has a key calles questions, and title
    ASSERT_TRUE(responseJson.has_field("questions"));
    ASSERT_TRUE(responseJson.has_field("title"));

}

TEST_F(logicTest, QuestionsAnswer) {
    // first get the questions
    web::json::value requestBody;

    // Send a valid POST request
    auto response = sendGetRequest("/questions", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    
    web::json::value responseJson = response->extract_json().get();
    auto questions = responseJson.at("questions");
    
    // Create a JSON object for the request body
    web::json::value requestBodyAnswer = web::json::value::object();
    requestBodyAnswer[U("title")] = responseJson.at("title");
    requestBodyAnswer[U("userID")] = web::json::value::string(U("guest"));
    requestBodyAnswer[U("answers")] = web::json::value();
    // Answer all questions, the questions are the keys in the questions object, but remove the three first chars
    for (auto question : questions.as_object()) {
        requestBodyAnswer[U("answers")][question.first.substr(3)] = web::json::value::number(1);
    }
    // Send a valid POST request
    auto responseAnswer = sendPostRequest("/questions", requestBodyAnswer);

    ASSERT_NE(responseAnswer, nullptr);
    ASSERT_EQ(status_codes::Created, responseAnswer->status_code());

    // Assert that the response has carbonscore number
    web::json::value responseJsonAnswer = responseAnswer->extract_json().get();
    ASSERT_TRUE(responseJsonAnswer["response"].has_field("carbonScore"));
    ASSERT_TRUE(responseJsonAnswer["response"]["carbonScore"].is_number());
}

TEST_F(logicTest, InvalidQuestionsAnswer) {
    // first get the questions
    web::json::value requestBody;

    // Send a valid POST request
    auto response = sendGetRequest("/questions", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    
    web::json::value responseJson = response->extract_json().get();
    auto questions = responseJson.at("questions");
    
    // Create a JSON object for the request body
    web::json::value requestBodyAnswer = web::json::value::object();
    requestBodyAnswer[U("title")] = responseJson.at("title");
    requestBodyAnswer[U("userID")] = web::json::value::string(U("guest"));
    requestBodyAnswer[U("answers")] = web::json::value();
    // Answer all questions, the questions are the keys in the questions object
    for (auto question : questions.as_object()) {
        requestBodyAnswer[U("answers")][question.first] = web::json::value::number(1);
    }
    // Send a valid POST request
    auto responseAnswer = sendPostRequest("/questions", requestBodyAnswer);

    ASSERT_NE(responseAnswer, nullptr);
    ASSERT_EQ(status_codes::BadRequest, responseAnswer->status_code());
}

TEST_F(logicTest, QuestionsUpdate) {
    // first get the questions
    web::json::value requestBody;

    // Send a valid POST request
    auto response = sendGetRequest("/questions", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    
    web::json::value responseJson = response->extract_json().get();
    auto questions = responseJson.at("questions");
    
    // Create a JSON object for the request body
    web::json::value requestBodyAnswer = web::json::value::object();
    requestBodyAnswer[U("title")] = responseJson.at("title");
    requestBodyAnswer[U("userID")] = web::json::value::string(U("guest"));
    requestBodyAnswer[U("answers")] = web::json::value();
    // Answer all questions, the questions are the keys in the questions object, but remove the three first chars
    for (auto question : questions.as_object()) {
        requestBodyAnswer[U("answers")][question.first.substr(3)] = web::json::value::number(1);
    }
    // Send a valid POST request
    auto responseAnswer = sendPostRequest("/questions", requestBodyAnswer);

    ASSERT_NE(responseAnswer, nullptr);
    ASSERT_EQ(status_codes::Created, responseAnswer->status_code());

    // Assert that the response has carbonscore number
    web::json::value responseJsonAnswer = responseAnswer->extract_json().get();
    ASSERT_TRUE(responseJsonAnswer["response"].has_field("carbonScore"));
    ASSERT_TRUE(responseJsonAnswer["response"]["carbonScore"].is_number());

    // Answer all questions again
    requestBodyAnswer[U("answers")] = web::json::value();
    for (auto question : questions.as_object()) {
        requestBodyAnswer[U("answers")][question.first.substr(3)] = web::json::value::number(2);
    }
    auto secondResponseAnswer = sendPostRequest("/questions", requestBodyAnswer);

    ASSERT_NE(secondResponseAnswer, nullptr);
    ASSERT_EQ(status_codes::Created, secondResponseAnswer->status_code());

    // compare the two carbon scores
    web::json::value secondResponseJsonAnswer = secondResponseAnswer->extract_json().get();
    ASSERT_TRUE(secondResponseJsonAnswer["response"].has_field("carbonScore"));
    ASSERT_TRUE(secondResponseJsonAnswer["response"]["carbonScore"].is_number());
    ASSERT_NE(responseJsonAnswer["response"]["carbonScore"].as_double(), secondResponseJsonAnswer["response"]["carbonScore"].as_double());
}
