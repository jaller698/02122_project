/* Written by Christian
 * This file contains the tests for the logic functions 
*/

#include "logic_test.h"

// Test the get request for the average
TEST_F(logicTest, GetAverage) {
    web::json::value requestBody = web::json::value::object();

    auto response = sendGetRequest("/average", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    // Test that the response is a number
    web::json::value responseJson = response->extract_json().get();
    ASSERT_TRUE(responseJson.is_number());
}

// Test the get request for the comparison data, with just a single country
TEST_F(logicTest, GetSingleComparisonData) {
    // Test with a single country, we use ISO 3166-1 alpha-2 codes
    web::json::value requestBody = web::json::value::object();
    requestBody["landcodes"] = web::json::value::array();
    requestBody["landcodes"][0] = web::json::value::string("DNK");

    auto response = sendGetRequest("/comparison", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    // assert that the response is an array, with a single item
    web::json::value responseJson = response->extract_json().get();
    ASSERT_TRUE(responseJson.is_array());
    ASSERT_EQ(1, responseJson.as_array().size());
    
}

// Test the get request for the comparison data, with an invalid country
TEST_F(logicTest, GetSingleComparisonDataInvalid) {
    // Send a request with an invalid landcode, we use ISO 3166-1 alpha-2 codes
    web::json::value requestBody = web::json::value::object();
    requestBody["landcodes"] = web::json::value::array();
    requestBody["landcodes"][0] = web::json::value::string("NL");

    auto response = sendGetRequest("/comparison", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::BadRequest, response->status_code());

    // assert that the response is null
    web::json::value responseJson = response->extract_json().get();
    ASSERT_TRUE(responseJson.is_null());   
}

// Test the get request for the comparison data, with multiple countries
TEST_F(logicTest, GetMultipleComparisonData) {
    // Test with multiple countries
    web::json::value requestBody = web::json::value::object();
    requestBody["landcodes"] = web::json::value::array();
    requestBody["landcodes"][0] = web::json::value::string("DNK");
    requestBody["landcodes"][1] = web::json::value::string("NLD");

    auto response = sendGetRequest("/comparison", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::OK, response->status_code());

    // assert that the response is an array, with a two items
    web::json::value responseJson = response->extract_json().get();
    ASSERT_TRUE(responseJson.is_array());
    ASSERT_EQ(2, responseJson.as_array().size());

    // assert that the response is an array of different objects
    web::json::value firstObject = responseJson.as_array().at(0);
    web::json::value secondObject = responseJson.as_array().at(1);
    ASSERT_NE(firstObject, secondObject);
    
}

// Test the get request for the comparison data, with multiple invalid countries
TEST_F(logicTest, GetMultipleComparisonDataInvalid) {
    // Test with invalid landcodes, should return a bad request
    web::json::value requestBody = web::json::value::object();
    requestBody["landcodes"] = web::json::value::array();
    requestBody["landcodes"][0] = web::json::value::string("NL");
    requestBody["landcodes"][1] = web::json::value::string("BE");

    auto response = sendGetRequest("/comparison", requestBody);
    ASSERT_NE(response, nullptr);
    ASSERT_EQ(status_codes::BadRequest, response->status_code());

    // assert that the response is null
    web::json::value responseJson = response->extract_json().get();
    ASSERT_TRUE(responseJson.is_null());
}

