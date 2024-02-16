CXX := g++
CXXFLAGS := -I . -Wall -Wextra -lmysqlcppconn -lcpprest -lssl -lcrypto

DEPS := database_connector.hpp rest_api.h 
SRC := main.cpp data/database_connector.cpp rest/rest_api.cpp

all: $(SRC)
	$(CXX) -o main $(SRC) $(CXXFLAGS)

run: all
	./main
