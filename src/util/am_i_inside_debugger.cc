#include "am_i_inside_debugger.h"

#include <QDebug>

#ifdef Q_OS_IOS
#    include <sys/sysctl.h>
#endif // Q_OS_IOS

#include <stdbool.h>
#include <sys/types.h>
#if !defined( Q_OS_WIN )
#    include <unistd.h>
#endif

#ifdef Q_OS_ANDROID
#    include "android/detect_debugging.cc"
#endif // Q_OS_ANDROID

namespace project
{
#if !defined( Q_OS_ANDROID ) && !defined( Q_OS_IOS )
bool OkToEnableAssertions()
{
    // If we are running a desktop version, we are DEFINITELY testing/debugging.
    // End users only have access to the mobile version.
    return true;
}
#endif // all non-mobile platforms

#ifdef Q_OS_ANDROID
bool OkToEnableAssertions()
{
#    ifdef FBD_APP_INTEGRATION_TESTS
    // In the "itests" build (not for customers), enable assertions:
    return true;
#    endif
    // In production, no assertions unless we are debugging. This way we know a
    // developer is in control.
    // (Suppress assertions for end users always.)
    return AndroidDebuggerConnected();
}
#endif // Q_OS_ANDROID

#ifdef Q_OS_IOS
bool OkToEnableAssertions()
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
#    ifdef FBD_APP_INTEGRATION_TESTS
    // In the "itests" build (not for customers), enable assertions:
    return true;
#    endif

    // Code from Apple, first encountered via:
    // https://stackoverflow.com/questions/33177182/detect-if-swift-app-is-being-run-from-xcode
    int mib[ 4 ];
    struct kinfo_proc info;
    size_t size = 0;

    memset( mib, 0, sizeof( mib ) );
    memset( &info, 0, sizeof( kinfo_proc ) );

    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.

    info.kp_proc.p_flag = 0;

    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.

    mib[ 0 ] = CTL_KERN;
    mib[ 1 ] = KERN_PROC;
    mib[ 2 ] = KERN_PROC_PID;
    mib[ 3 ] = getpid();

    // Call sysctl.
    size = sizeof( info );
    const int sysctlError = sysctl( mib, sizeof( mib ) / sizeof( *mib ), &info, &size, NULL, 0 );
    if( sysctlError )
    {
        qCritical() << "call to sysctl returned" << sysctlError;
    }

    // We're being debugged if the P_TRACED flag is set.
    return ( ( info.kp_proc.p_flag & P_TRACED ) != 0 );
}
#endif // Q_OS_IOS

} // namespace project
