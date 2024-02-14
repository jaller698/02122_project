#include "data/database_connector.hpp"
#include "rest/rest_api.h"

int main() {
    createTableAndShowContents();
    listen();
    return 0;
}