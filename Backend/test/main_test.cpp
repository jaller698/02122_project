#include "logic_test.h"


int main(int argc, char** argv) {
    INFO("Running main_test.cpp");

    std::atomic<bool> stop_flag{false};

    std::thread rest_api_thread = std::thread([&stop_flag]() {
        RestAPIEndpoint rest_api_endpoint;
        rest_api_endpoint.listen(stop_flag);
    });
    ::testing::InitGoogleTest(&argc, argv);
    int return_code = RUN_ALL_TESTS();
    
    stop_flag.store(true);
    if (rest_api_thread.joinable()) {
        rest_api_thread.join();
    }

    return return_code;
}