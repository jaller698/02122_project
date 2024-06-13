#include "common.h"

/* Written by Christian
*  Main function of the program, starts the database and the REST API
*  The REST API is started in the main thread, but can be started in seperate threads
*  Useful for testing purposes
*/

int main() {
    try
    {
       dataBaseStart db;
       if (db.init() != 0) {
            WARNING("Something went wrong during the setup, exiting program");
            std::terminate();
       }
       RestAPIEndpoint rest_api_endpoint;
       std::atomic<bool> stop_flag{false};
       rest_api_endpoint.listen(stop_flag);
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