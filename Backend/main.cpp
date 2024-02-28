#include "data/database_connector.hpp"
#include "rest/rest_api.h"

int main() {
    dataBaseStart db;
    db.createTableAndShowContents();
    RestAPIEndpoint rest_api_endpoint;
    rest_api_endpoint.listen();
    return 0;
}