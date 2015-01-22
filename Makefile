.PHONY: all rebuild clean run dirtree

EXTERNALS		:= externals
BUILD			:= build
DIST			:= dist
TEST			:= test
RES			:= resources

LIB			:= lib
TGT			:= Simple
TGT_TEST		:= Simple_test

CXX			:= clang++-3.2
RM			:= rm
MKDIR			:= mkdir
FIND			:= find
CP			:= cp

## Compilation common flags
#CXX			:= g++
#CXXFLAGS_COMMON	:= -std=gnu++11 -Wall -Iinclude -I$(EXTERNALS)/SFML/include
#cmake -DCMAKE_CXX_COMPILER="clang++" -DCMAKE_CXX_FLAGS="-std=c++11 -stdlib=libc++ -U__STRICT_ANSI__"
CXXFLAGS_COMMON		:= -stdlib=libc++ -std=c++11 -Iinclude -I$(EXTERNALS)/SFML/include
CXXFLAGS			:= $(CXXFLAGS_COMMON)
DEPSFLAGS			:= -MMD -MP

## Linker common flags
LD_FLAGS		:= -L$(LIB) #-lsfml-graphics -lsfml-window -lsfml-system

## Runtime flags
LD_LIBRARY_PATH 	:= $(LIB):$(LD_LIBRARY_PATH)

## Source objects
CPP_FILES		:= $(shell $(FIND) src -iname *.cpp)
OBJS			:= $(patsubst src%, $(BUILD)/$(DIST)%,$(patsubst %.cpp, %.o, $(CPP_FILES)))
DEPS			:= $(OBJS:.o=.d)

## Test objects
CPP_TEST_FILES		:= $(filter-out src/main.cpp, $(shell $(FIND) src test -iname *.cpp))
TEST_OBJS			:= $(patsubst src%, $(BUILD)/$(TEST)%, $(patsubst test%, $(BUILD)/$(TEST)%,$(patsubst %.cpp, %.o, $(CPP_TEST_FILES))))
TEST_DEPS			:= $(TEST_OBJS:.o=.d)		

## Test specific compilation and linking flags
GMOCK	        	:= $(EXTERNALS)/gmock-1.7.0
LD_FLAGS_TEST		:= $(LD_FLAGS) -lpthread -lgmock
CXXFLAGS_TEST		:= $(CXXFLAGS_COMMON) -I$(GMOCK)/include -I$(GMOCK)/gtest/include -Itest/mocks

## Targets
all: $(BUILD)/$(DIST)/$(TGT)

rebuilt: clean all

test: $(BUILD)/$(TEST)/$(TGT_TEST)
	./$(BUILD)/$(TEST)/$(TGT_TEST)

dirtree:
	@$(MKDIR) -p $(BUILD)/$(DIST) $(BUILD)/$(TEST)

run: $(BUILD)/$(DIST)/$(TGT) $(BUILD)/$(DIST)/$(RES)
	@cd $(BUILD)/$(DIST) && ./$(TGT)

clean:
	@$(RM) -Rf $(BUILD)

$(BUILD)/$(TEST)/$(TGT_TEST): $(TEST_OBJS)
	$(CXX) $(CXXFLAGS_TEST) -o $(BUILD)/$(TEST)/$(TGT_TEST) $(shell $(FIND) $(BUILD)/$(TEST) -iname *.o) $(LD_FLAGS_TEST)

$(BUILD)/$(DIST)/$(TGT): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(BUILD)/$(DIST)/$(TGT) $(shell $(FIND) $(BUILD)/$(DIST) -iname *.o) $(LD_FLAGS)

$(BUILD)/$(DIST)/%.o: src/%.cpp |  dirtree
	$(CXX) $(CXXFLAGS) $(DEPSFLAGS) -c $< -o $@

$(BUILD)/$(TEST)/%.o: test/%.cpp |  dirtree
	$(CXX) $(CXXFLAGS_TEST) $(DEPSFLAGS) -c $< -o $@

$(BUILD)/$(TEST)/%.o: src/%.cpp |  dirtree
	$(CXX) $(CXXFLAGS_TEST) $(DEPSFLAGS) -c $< -o $@

$(BUILD)/$(DIST)/$(RES):
	@$(CP) -Rf $(RES)/* $(BUILD)/$(DIST)/

-include $(DEPS)
-include $(TEST_DEPS)
