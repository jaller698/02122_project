# To compile the project, run `make` in the terminal. To run the project, run `make run` in the terminal. To clean the project, run `make clean` in the terminal.
# To run in debug mode (with debug prints), run `make DEBUG=1 (run)` in the terminal.

CXX := g++
CXXFLAGS := -I . -Wall -Wextra -lmysqlcppconn -lcpprest -lssl -lcrypto

DEPS := database_connector.hpp rest_api.h 
SRC := main.cpp data/database_connector.cpp rest/rest_api.cpp

OBJ_DIR := _build
OBJ := $(addprefix $(OBJ_DIR)/,$(SRC:.cpp=.o))

CXXFLAGS += $(if $(DEBUG),-DDEBUG)

all: main

main: $(OBJ)
	$(CXX) -o $@ $^ $(CXXFLAGS)

$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) -c -o $@ $< $(CXXFLAGS)

run: main
	./main

clean:
	rm -f main $(OBJ)
