#include "common.h"

int main() {
    try
    {
       dataBaseStart db;
       if (db.init() != 0) {
            WARNING("Something went wrong during the setup, exiting program");
            std::terminate();
       }
       RestAPIEndpoint rest_api_endpoint;
       rest_api_endpoint.listen();
    }
    catch(const std::exception& e)
    {
        ERROR("Error in top-level of program ",e);
    } catch (...)
    {
        ERROR("Unknown error in top-level of program",std::runtime_error("Unknown error"));
    }
    
    
    return 0;
}