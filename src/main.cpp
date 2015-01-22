#include <iostream>
#include "Simple.hpp"

int main(int argc, char **argv) {
    auto sp = std::make_shared<Simple>();
    std:: cout << sp->getValue();
    return 0;
}
