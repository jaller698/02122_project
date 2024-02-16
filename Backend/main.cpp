#include "data/database_connector.hpp"
#include "rest/rest_api.h"

int main() {
    createTableAndShowContents();
    RestAPIEndpoint rest_api_endpoint;
    rest_api_endpoint.listen();
    return 0;
}