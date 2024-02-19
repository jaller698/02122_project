# To compile the project, run `make` in the terminal. To run the project, run `make run` in the terminal. To clean the project, run `make clean` in the terminal.
# To run in debug mode (with debug prints), run `make DEBUG=1 (run)` in the terminal.

CXX := g++
CXXFLAGS := -I . -Wall -Wextra -lmysqlcppconn -lcpprest -lssl -lcrypto
TEST_FLAGS := $(CXXFLAGS) -lgtest 

DEPS := database_connector.hpp rest_api.h 
SRC := main.cpp data/database_connector.cpp rest/rest_api.cpp
TEST_SRC := test/main_test.cpp test/test_rest_api.cpp

OBJ_DIR := _build
OBJ := $(addprefix $(OBJ_DIR)/,$(SRC:.cpp=.o))
TEST_OBJ := $(addprefix $(OBJ_DIR)/,$(TEST_SRC:.cpp=.o))

CXXFLAGS += $(if $(DEBUG),-DDEBUG)

all: main

main: $(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS)

$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

run: main
	./main

test: $(TEST_OBJ)
	$(CXX) -o bin_test $^ $(TEST_FLAGS)
	./bin_test

clean:
	rm -f main $(OBJ)
