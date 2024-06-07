#include "query_comparison_data.h"


// Query the comparison data from the World Bank API
// small helper function
// see data provided here: https://data.worldbank.org/indicator/EN.ATM.CO2E.PC
std::vector<std::tuple<std::string, std::string, std::string>> query_comparison_data() {
    try {
        DEBUG_PRINT("Querying comparison data, from World Bank API");
        web::http::client::http_client client("https://api.worldbank.org");
        web::http::http_request request(web::http::methods::GET);
        request.set_request_uri("/v2/country/all/indicator/EN.ATM.CO2E.PC?format=json&mrv=1&per_page=300");
        web::http::http_response response = client.request(request).get();
        if (response.status_code() != http::status_codes::OK) {
            throw std::runtime_error("Error in getting data from World Bank API");
        }
        auto data = response.extract_json().get();
        std::vector<std::tuple<std::string, std::string, std::string>> country_data;
        bool is_country_data_ready = false;
        for (auto &country : data.at(1).as_array()) {
            // wait for afghanistan since that is the first country, before that it is regions / classifications
            if (country.at("countryiso3code").as_string() == "AFG") {
                is_country_data_ready = true;
            } else if (!is_country_data_ready) {
                continue;
            }
            std::string country_code = country.at("countryiso3code").as_string();
            std::string country_name = country.at("country").at("value").as_string();
            if (country.at("value").is_null()) {
                WARNING("No value for " + country_name);
                continue;
            }
            double value = country.at("value").as_double() * 1000; // value is in metric tons, we want it in kg
            DEBUG_PRINT("Value for " + country_name + ": " + std::to_string(value));
            country_data.push_back(std::make_tuple(country_code, country_name, std::to_string(value)));
        }
    return country_data;
    } catch (const std::exception &e) {
        ERROR("Error in handling comparison: ", e);
    }
}