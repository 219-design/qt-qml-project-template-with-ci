#include "x_unistd.h"

#if defined( WIN32 ) || defined( _WIN32 )
#    include <windows.h>
#else
#    include <unistd.h>
#endif

namespace project
{
void MilliSleep( const int ms )
{
#if defined( WIN32 ) || defined( _WIN32 )
    Sleep( static_cast<DWORD>( ms ) );
#else
    usleep( static_cast<useconds_t>( ms ) * 1000 ); // usleep takes sleep time in us (1 millionth of a second)
#endif
}
} // namespace project
