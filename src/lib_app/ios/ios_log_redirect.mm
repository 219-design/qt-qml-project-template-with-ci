#include "ios_log_redirect.h"

#import <Foundation/Foundation.h>
#import <Foundation/NSFileManager.h>

#include "src/minutil/logger.h"

namespace project
{
void WhenOnIos_RerouteStdoutStderrToDeviceFilesystem()
{
    if( isatty( STDERR_FILENO ) )
    {
        project::log( "logs.mm: SKIPPING log re-route to disk. Console is attached.\n" );
        return;
    }

    /*
      As long as we write to "Documents/", and as long as the Info.plist is
      configured properly, then the iPad user can open the "Files app" and
      browse these logs from the "On My iPad" browsing location.

      The necessary plist keys are:

       <key>UIFileSharingEnabled</key>
       <true/>
       <key>LSSupportsOpeningDocumentsInPlace</key>
       <true/>
      */
    NSString* logFileErr = [NSString stringWithFormat:@"%s/Documents/my_qt_template_app_log.txt",
                                     [NSHomeDirectory() UTF8String]];
    FILE* fileErr = fopen( [logFileErr UTF8String], "a" );
    NSString* logFileOut = [NSString stringWithFormat:@"%s/Documents/my_qt_template_app_log.out.txt",
                                     [NSHomeDirectory() UTF8String]];
    FILE* fileOut = fopen( [logFileOut UTF8String], "a" );

    // replace stdout with our file
    dup2( fileno( fileOut ), STDOUT_FILENO );
    // replace stderr with our file
    dup2( fileno( fileErr ), STDERR_FILENO );
}
} // namespace project
