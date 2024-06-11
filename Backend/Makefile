# To compile the project, run `make` in the terminal. To run the project, run `make run` in the terminal. To clean the project, run `make clean` in the terminal.
# To run in debug mode (with debug prints), run `make DEBUG=1 (run)` in the terminal.

CXX := g++
CXXFLAGS := -I . -std=c++20 -Wall -Wextra -lmysqlcppconn -lcpprest -lssl -lcrypto -Werror
ifdef DEBUG
	CXXFLAGS += -DDEBUG
endif

DEPS := database_connector.hpp rest_api.h logic.h calculate_score.h query_comparison_data.h
SRC := data/database_connector.cpp rest/rest_api.cpp logic/logic.cpp logic/calculate_score.cpp data/query_comparison_data.cpp

OBJ_DIR := _build
MAIN_OBJ := $(OBJ_DIR)/main.o
OBJ := $(addprefix $(OBJ_DIR)/,$(SRC:.cpp=.o))

all: main

main: $(OBJ) $(MAIN_OBJ) 
	$(CXX) -o $@ $^ $(CXXFLAGS)

$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

run: main
	./main

test: test.Makefile
	$(MAKE) -f test.Makefile

clean:
	rm -rf $(OBJ_DIR) main bin_test
