#include "common.h"

int main() {
    try
    {
       dataBaseStart db;
        db.init();
        RestAPIEndpoint rest_api_endpoint;
        rest_api_endpoint.listen();
    }
    catch(const std::exception& e)
    {
        ERROR("error in main",e);
    }
    
    
    return 0;
}