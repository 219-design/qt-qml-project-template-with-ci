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
    Sleep( ms );
#else
    usleep( ms * 1000 ); // usleep takes sleep time in us (1 millionth of a second)
#endif
}
} // namespace project
