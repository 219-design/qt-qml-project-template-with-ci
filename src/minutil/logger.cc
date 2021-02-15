#include "logger.h"

#undef printf // undo the "poison" from our own logger.h file
#undef fprintf // undo the "poison" from our own logger.h file

#include <cassert>
#include <iostream>
#include <sstream>
#include <stdarg.h>
#include <stdio.h>
#include <string>
#include <thread>
#include <time.h>

#if defined( WIN32 ) || defined( _WIN32 )
#    include <io.h>
#    include <stdlib.h>
#    include <wchar.h>
#    include <windows.h>
#else
#    include <unistd.h>
#endif //if defined( WIN32 ) || defined( _WIN32 )

namespace project
{
namespace
{
std::string loggingGlobal_AppVersion;

#if defined( WIN32 ) || defined( _WIN32 )
std::string GetDateTimeString()
{
    SYSTEMTIME result = { 0 };

    GetLocalTime( &result );

    // YYYY-MM-DD_HH_MM_SS
    constexpr int BUFF_SIZE = 32;
    char buff[ BUFF_SIZE ];
    memset( buff, '\0', BUFF_SIZE );
    const int printfResult = snprintf( buff,
        sizeof( buff ),
        "%04d-%02d-%02d %02d:%02d:%02d",
        ( result.wYear ), // tm struct counts years from 1900
        result.wMonth, // tm struct counts months starting with 0
        result.wDay,
        result.wHour, result.wMinute, result.wSecond );
    // Next line added per: https://stackoverflow.com/questions/51534284/how-to-circumvent-format-truncation-warning-in-gcc
    assert( printfResult < static_cast<int>( sizeof( buff ) ) );

    return std::string( buff );
}
#else
std::string GetDateTimeString()
{
    struct tm result;
    time_t ltime = time( nullptr );
    // localtime_r (note the '_r' is threadsafe, as opposed to the non-r version)
    localtime_r( &ltime, &result );

    // YYYY-MM-DD_HH_MM_SS
    constexpr int BUFF_SIZE = 32;
    char buff[ BUFF_SIZE ];
    memset( buff, '\0', BUFF_SIZE );
    const int printfResult = snprintf( buff,
        sizeof( buff ),
        "%04d-%02d-%02d %02d:%02d:%02d",
        ( result.tm_year + 1900 ), // tm struct counts years from 1900
        result.tm_mon + 1, // tm struct counts months starting with 0
        result.tm_mday,
        result.tm_hour, result.tm_min, result.tm_sec );
    // Next line added per: https://stackoverflow.com/questions/51534284/how-to-circumvent-format-truncation-warning-in-gcc
    assert( printfResult < static_cast<int>( sizeof( buff ) ) );

    return std::string( buff );
}
#endif //if defined( WIN32 ) || defined( _WIN32 )

std::string GetPrefix()
{
    std::string prefix = GetDateTimeString();

    prefix += " [v-" + loggingGlobal_AppVersion + "]";

    {
        std::ostringstream stringStream;
        stringStream << "[pid:" << getpid() << "]";
        prefix += stringStream.str();
    }

    {
        std::ostringstream stringStream;
        stringStream << "[thr:" << std::this_thread::get_id() << "]";
        prefix += stringStream.str();
    }

    prefix += " ";
    return prefix;
}
} // namespace

// Call this very early in your 'main' function, assuming you have a version_hash:
void SetAppVersionStringForLogging( const char* version )
{
    FASSERT( version, "please do not pass a null char* into here" );
    FASSERT( loggingGlobal_AppVersion.empty(), "you probably only intend to call this ONCE, no?" );
    if( version )
    {
        loggingGlobal_AppVersion = std::string( version );
    }
}

void log( const char* fmt, ... )
{
    std::string prefix = GetPrefix();
    prefix += std::string( fmt );
    if( prefix.back() != '\n' )
    {
        prefix += "\n";
    }

    va_list args;
    va_start( args, fmt );
    vfprintf( stderr, prefix.c_str(), args );
    va_end( args );
}

} // namespace project
