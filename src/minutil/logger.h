//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJ_LIB_MINUTIL_LOGGER_H
#define PROJ_LIB_MINUTIL_LOGGER_H

#include "util-assert.h" // we include this before our "poison" (below), to allow it fprintf

namespace project
{
// Call this very early in your 'main' function, assuming you have a version_hash:
void SetAppVersionStringForLogging( const char* version );

#if defined( WIN32 ) || defined( _WIN32 )
// Wrapper around fprintf to STDERR. Adds timestamp, thread_id, etc.
void log( const char* fmt, ... );
#else
// Wrapper around fprintf to STDERR. Adds timestamp, thread_id, etc.
void log( const char* fmt, ... ) __attribute__( ( format( printf, 1, 2 ) ) );
#endif //if defined(WIN32) || defined(_WIN32)

/*
    https://gcc.gnu.org/onlinedocs/gcc-4.0.1/gcc/Function-Attributes.html#Function-Attributes

    format (archetype, string-index, first-to-check)

    The format attribute specifies that a function takes printf, scanf, strftime or strfmon style arguments which should be type-checked against a format string. For example, the declaration:

                    __attribute__ ((format (printf, 2, 3)));

    The parameter string-index specifies which argument is the format string
    argument (starting from 1), while first-to-check is the number of the first
    argument to check against the format string. For functions where the
    arguments are not available to be checked (such as vprintf), specify the
    third parameter as zero.
  */

} // namespace project

// Intentionally "poison" these symbols to help catch code that forgot to use project::log
#define printf TO_FIX_THIS_ERROR_SEARCH_AND_REMOVE_YOUR_USE_OF_printf
#define fprintf TO_FIX_THIS_ERROR_SEARCH_AND_REMOVE_YOUR_USE_OF_fprintf
#define cerr TO_FIX_THIS_ERROR_SEARCH_AND_REMOVE_YOUR_USE_OF_cerr
#define cout TO_FIX_THIS_ERROR_SEARCH_AND_REMOVE_YOUR_USE_OF_cout

#endif // PROJ_LIB_MINUTIL_LOGGER_H
