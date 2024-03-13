#include "common.h"

int main() {
    dataBaseStart db;
    db.init();
    RestAPIEndpoint rest_api_endpoint;
    rest_api_endpoint.listen();
    return 0;
}