#include "ios_log_redirect.h"

#if defined( __APPLE__ )
#    include <CoreFoundation/CoreFoundation.h>
#    include <TargetConditionals.h>
#endif // defined(__APPLE__)

namespace project
{
void WhenOnIos_RerouteStdoutStderrToDeviceFilesystem()
{
    // Not on iOS. So this is a no-op.

#if defined( __APPLE__ ) && ( TARGET_OS_IPHONE )
#    error "the iOS build should use the NON-EMPTY implementation of this func"
#endif
}
} // namespace project
