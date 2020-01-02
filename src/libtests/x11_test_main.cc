#include "gmock/gmock.h"
#include "gtest/gtest.h"

int main( int argc, char* argv[] )
{
    testing::InitGoogleTest( &argc, argv );
    testing::InitGoogleMock( &argc, argv );

    // TODO. get PID of Xvfb (and start it running)

    int rc = RUN_ALL_TESTS();

    // TODO. kill Xvfb

    return rc;
}
