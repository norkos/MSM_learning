#include <iostream>
#include <boost/concept_check.hpp>
#include "Simple.hpp"
#include "controller.hpp"

int main(int argc, char **argv) {
    auto sp = std::make_shared<Simple>();
    std:: cout << sp->getValue();
    
    using namespace atm;
    controller p;
    p.start();
    
    return 0;
}
