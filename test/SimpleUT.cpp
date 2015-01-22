#include "Simple.hpp"
#include <gmock/gmock.h>

namespace test {

namespace GT = ::testing;

class simple_test : public GT::Test{
};

TEST_F(simple_test, isOk)
{
    //given
    Simple sut;
    EXPECT_TRUE(true);
}

} // namespace test