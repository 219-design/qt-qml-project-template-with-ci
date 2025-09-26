#include "gmock/gmock.h"
#include "gtest/gtest.h"

#if defined( __linux__ )
#    include "src/minutil/debug_sanitizer_config.cc" // <-- not a header! meant as inline code here.
#endif // #if defined( __linux__ )

int main( int argc, char* argv[] )
{
    testing::InitGoogleTest( &argc, argv );
    testing::InitGoogleMock( &argc, argv );

    return RUN_ALL_TESTS();
}
