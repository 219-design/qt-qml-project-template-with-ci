#ifndef CROSSPLATFORM_UTILITY_CODE_CASSERT_WRAPPER
#define CROSSPLATFORM_UTILITY_CODE_CASSERT_WRAPPER

//#define FLEX_DISABLE_ASSERT // <--- disabling should be done in a release build

// If NDEBUG is defined as a macro name at the point in the source code where <cassert> is included,
// then assert does nothing.
#ifdef NDEBUG
// Hard-enabling of assert() even if NDEBUG is defined
#    define NDEBUG_WAS_SET_FASSERT_HEADER
#    undef NDEBUG
#
#    include <cassert>
#endif

#include <signal.h> // for raise
#include <stdio.h> //  for stderr
#include <stdlib.h> // for getenv
#include <string.h>

#if defined( _WIN32 )
#    include <Windows.h>
#    include <assert.h>
#endif // #if defined(_WIN32)

#if defined( __APPLE__ )
#    include <CoreFoundation/CoreFoundation.h>
#    include <TargetConditionals.h>
#    define _putenv putenv
#endif // defined(__APPLE__)

#if defined( __linux__ )
#    define _putenv putenv
#    include <unistd.h> // for isatty
#endif // defined(__linux__)

static inline void Suppress_All_Assertions()
{
// if asserts have been BUILD-TIME compiled away, then do NOT bother calling putenv
#ifndef FLEX_DISABLE_ASSERT

    static const char* setting = "FLEX_SUPALL_ASRT=1";
    // should return 0 for SUCCESS:
    /*const int ret =*/_putenv( (char*) setting );

#endif // FLEX_DISABLE_ASSERT
}

static inline void UnSuppress_All_Assertions()
{
// if asserts have been BUILD-TIME compiled away, then do NOT bother calling putenv
#ifndef FLEX_DISABLE_ASSERT

    static const char* negation = "FLEX_SUPALL_ASRT=";
    // should return 0 for SUCCESS:
    /*const int ret =*/_putenv( (char*) negation ); // on win32, this is enough to nullify the var.

#    if !defined( _WIN32 )
    /*const int ret =*/unsetenv( "FLEX_SUPALL_ASRT" ); // on posix, the above set it to "", and HERE we nullify it
#    endif //#if ! defined(_WIN32)

#endif // FLEX_DISABLE_ASSERT
}

// break into the debugger
static inline void TrapDebug()
{
#if defined( _WIN32 )
    // If just-in-time (JIT) debugging is working properly, then one might
    // reasonbly choose to remove the 'IsDebugger' check and just always provoke
    // the EXCEPTION_BREAKPOINT.  When just-in-time debugging works properly,
    // you would then get a pop-up offering to attach a debugger, despite you
    // having launched the process outside of a debugger. If you trust
    // just-in-time debugging, then remove the check. However, on Windows 10
    // many people struggle to get just-in-time working reliably.
    if( IsDebuggerPresent() )
    {
        // if this is called OUTSIDE of a debugger (and when JIT is
        // uncooperative), then it will abort the program. When called in a
        // debugger, it behaves just as though you had manually set a
        // breakpoint.
        __debugbreak();
    }
#elif defined( __APPLE__ )
    raise( SIGTRAP );
#elif defined( __linux__ )
    raise( SIGTRAP );
#else
// FUTURE_PLATFORMS_TBD
#endif // Win/Apple
}

static inline void ShowOnStderr(
    const char* title,
    const char* message,
    const char* filename,
    const int line,
    const char* funcname )
{
    fprintf( stderr, "%s:\n", title );
    fprintf( stderr, "%s\n", funcname );
    fprintf( stderr, "%s:%d\n", filename, line );
    fprintf( stderr, "%s\n", message );
}

static inline void OptionToContinue(
    const char* title,
    const char* message,
    const char* filename,
    const int line,
    const char* funcname )
{
#if defined( _WIN32 )

    // suppress warnings about unused parameters on win32:
    (void) title;
    (void) message;
    (void) filename;
    (void) line;
    (void) funcname;

#elif defined( __APPLE__ ) && !( TARGET_OS_IPHONE )

    ShowOnStderr( title, message, filename, line, funcname );

    CFStringRef headerRef = CFStringCreateWithCString( NULL, title, kCFStringEncodingUTF8 );
    CFStringRef messageRef = CFStringCreateWithCString( NULL, message, kCFStringEncodingUTF8 );

    CFStringRef button1 = CFStringCreateWithCString( NULL, "Break", kCFStringEncodingUTF8 ); // defaultButtonTitle
    CFStringRef button2 = CFStringCreateWithCString( NULL, "Continue", kCFStringEncodingUTF8 ); // alternateButtonTitle

    CFOptionFlags response;

    CFUserNotificationDisplayAlert( 0, // timeout. (apparently in seconds) The amount of time to wait for the user to dismiss
        // the notification dialog before the dialog dismisses
        // itself. Pass 0 to have the dialog never time out.
        kCFUserNotificationCautionAlertLevel,
        NULL, // iconURL
        NULL, // soundURL
        NULL, // localizationURL
        headerRef,
        messageRef,
        button1, // defaultButtonTitle
        button2, // alternateButtonTitle
        NULL, // otherButtonTitle
        &response );

    CFRelease( headerRef );
    CFRelease( messageRef );
    CFRelease( button1 );
    CFRelease( button2 );

    if( response == kCFUserNotificationDefaultResponse )
    {
        // choice was "Break"
        TrapDebug();
    }
    else if( response == kCFUserNotificationAlternateResponse )
    {
        // choice was "Continue"
        // do nothing
    }
    else // if you add a 3rd button, this would be kCFUserNotificationOtherResponse
    {
        // either the notification timed out by itself (no user interaction),
        // or else the user hit the ESCAPE key

        fprintf( stderr, "ignoring opportunity to debug the FAIL (either due to inaction or ESC key)\n" );
    }

#elif defined( __unix__ ) || TARGET_OS_IPHONE

    ShowOnStderr( title, message, filename, line, funcname );

    char buf[ 16 ];
    bool retry = true;

    while( retry )
    {
        retry = false;

        fprintf( stderr, "[t] to trap/debug,\n"
                         "[x] to exit/abort,\n"
                         "[c] to continue,\n"
                         "[s] to suppress further assertions\n" );

        if( isatty( 0 ) && isatty( 1 ) )
        {
            fgets( buf, 8, stdin );
        }
        else
        {
            strcpy( buf, "X\n" );
        }

        if( ( buf[ 0 ] == 'X' || buf[ 0 ] == 'x' ) && buf[ 1 ] == '\n' )
        {
            abort();
        }
        else if( ( buf[ 0 ] == 'T' || buf[ 0 ] == 't' ) && buf[ 1 ] == '\n' )
        {
            TrapDebug();
        }
        else if( ( buf[ 0 ] == 'C' || buf[ 0 ] == 'c' ) && buf[ 1 ] == '\n' )
        {
            // just let things proceed
        }
        else if( ( buf[ 0 ] == 'S' || buf[ 0 ] == 's' ) && buf[ 1 ] == '\n' )
        {
            Suppress_All_Assertions();
        }
        else
        {
            retry = true;
        }
    }

#else
// FUTURE_PLATFORMS_TBD
#endif // Win/Apple
}

#if defined( __APPLE__ ) || defined( __linux__ )

static inline void Flex_Asrt_Unix( const char* message,
    const char* filename,
    const int line,
    const char* funcname )
{
    if( getenv( "FLEX_SUPALL_ASRT" ) )
    {
        return;
    }

    OptionToContinue( "FASSERT",
        message,
        filename,
        line,
        funcname );
}

static inline void Flex_Fail_Unix( const char* message,
    const char* filename,
    const int line,
    const char* funcname )
{
    if( getenv( "FLEX_SUPALL_ASRT" ) )
    {
        return;
    }

    OptionToContinue( "FFAIL",
        message,
        filename,
        line,
        funcname );
}

#endif //#if defined(__APPLE__)

static inline bool GetEnv_WinOnly( const char* name )
{
#if !defined( _WIN32 )

    // suppress warnings about unused parameters on mac:
    (void) name;
    return false;

#else

    size_t converted = 0;
#    ifdef _UNICODE
    wchar_t wtext[ 500 ];
    mbstowcs_s( &converted, wtext, 500, name, 480 );
    LPCWSTR ptr = wtext;
#    else
    LPCSTR ptr = name;
#    endif

    bool rslt = false;

    // get the size of the buffer
    DWORD dwRet = ::GetEnvironmentVariable( ptr, NULL, 0 );
    if( dwRet )
    {
        rslt = true;
    }

    return rslt;

#endif // #if defined(_WIN32)
}

/**
   INTERESTING ITEM ABOUT BAD INTERACTIONS OF IF/ELSE
   STRUCTURES AND PREPROCESSOR MACROS:

   http://stackoverflow.com/questions/154136/do-while-and-if-else-statements-in-c-c-macros
*/

/*
  If you have a Qt QString, then you need to pass it to FASSERT
  by doing something like this:

         QString message;

         FASSERT( 1 == 2, message.toUtf8() );

  If you are using std::string, then you will want to pass it in the following
  way:

         std::string message;

         FASSERT( 1 == 2, message.c_str() );

*/
#ifdef FLEX_DISABLE_ASSERT

// define it as "nothing." they will be "compiled out"
#    define FASSERT( cond, msg )

#    define FFAIL( msg )

#else // the ELSE is when we _ENABLE_ our assertions

#    if defined( _WIN32 )

// when assertions are enabled on Win:
#        define FASSERT( cond, msg )                                                  \
            __pragma( warning( push ) )                                               \
                __pragma( warning( disable : 4127 ) ) do                              \
            {                                                                         \
                if( !GetEnv_WinOnly( "FLEX_SUPALL_ASRT" ) )                           \
                {                                                                     \
                    if( !( cond ) )                                                   \
                    {                                                                 \
                        ShowOnStderr( "FASSERT", msg, __FILE__, __LINE__, __func__ ); \
                        TrapDebug();                                                  \
                    }                                                                 \
                    assert( ( cond ) && ( msg ) );                                    \
                }                                                                     \
            }                                                                         \
            while( 0 )                                                                \
            __pragma( warning( pop ) )

// when assertions are enabled on Win:
#        define FFAIL( msg )                                                    \
            __pragma( warning( push ) )                                         \
                __pragma( warning( disable : 4127 ) ) do                        \
            {                                                                   \
                if( !GetEnv_WinOnly( "FLEX_SUPALL_ASRT" ) )                     \
                {                                                               \
                    ShowOnStderr( "FFAIL", msg, __FILE__, __LINE__, __func__ ); \
                    TrapDebug();                                                \
                    assert( !msg );                                             \
                }                                                               \
            }                                                                   \
            while( 0 )                                                          \
            __pragma( warning( pop ) )

#    elif defined( __APPLE__ ) || defined( __linux__ )

// when assertions are enabled on Mac:
#        define FASSERT( cond, msg ) \
            if( ( cond ) )           \
            {                        \
            }                        \
            else                     \
                Flex_Asrt_Unix( msg, __FILE__, __LINE__, __func__ )

// when assertions are enabled on Mac:
#        define FFAIL( msg ) \
            Flex_Fail_Unix( msg, __FILE__, __LINE__, __func__ )

#    else
// FUTURE_PLATFORMS_TBD
#    endif // Win/Apple

#endif // #ifdef FLEX_DISABLE_ASSERT

#ifdef NDEBUG_WAS_SET_FASSERT_HEADER
// Restoring NDEBUG if it was enabled originally
#    define NDEBUG
#endif

#endif // CROSSPLATFORM_UTILITY_CODE_CASSERT_WRAPPER
