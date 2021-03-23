#ifndef PROJ_LIB_QUARANTINED_HEADERS_H
#define PROJ_LIB_QUARANTINED_HEADERS_H

#ifdef __GNUC__
// Avoid warnings in external headers that external team has not yet had time to investigate
#    pragma GCC system_header
#endif

#if defined( WIN32 ) || defined( _WIN32 )
#    pragma system_header
#endif // #if defined( WIN32 ) || defined( _WIN32 )

// Previously we were suppressing unsolved warnings by specifying the
// INCLUDEPATH for these headers using '-isystem'. However, that had an
// unacceptable side-effect: treating them with '-isystem' meant that when those
// headers got edited, our make system did NOT notice the changes and did NOT
// rebuild things that depended on those changed headers. This is our current
// solution, which so far has met both requirements: (1) suppress warnings in
// the headers listed right here and in no other headers, and (2) keep our make
// system SENSITIVE to changes in the headers listed, such that when they are
// edited, the necessary rebuilds DO happen.

#include "src/lib_app/sample_external_headers/sample_header_exempt_from_warnings.h"

#endif // PROJ_LIB_QUARANTINED_HEADERS_H
