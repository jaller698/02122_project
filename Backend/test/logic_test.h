#include <gtest/gtest.h>
#include "common.h"
#include "http_common.h"

/* Written by Christian
 * common class for all logic tests
 * it sets up the database before each test and resets it after each test
*/
class logicTest : public ::testing::Test {
    protected:
    void SetUp() override {
        // Set up any necessary resources before each test
        try {
            dataBaseStart db;
            db.init();
            //RestAPIEndpoint rest_api_endpoint;
            //rest_api_endpoint.listen();
        
        } catch (const std::exception& e) {
            ERROR("Error in top-level of test setup ", e);
        } catch (...) {
            ERROR("Unknown error in top-level of program", std::runtime_error("Unknown error"));
        }
    }
    void TearDown() override {
        dataBaseStart db;
        db.reset();
        // Clean up any resources after each test
    }
};