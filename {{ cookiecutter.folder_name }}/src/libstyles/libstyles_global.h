#ifndef TESTLIB_GLOBAL_H
#define TESTLIB_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined( LIBSTYLES_LIBRARY )
#    define LIBSTYLES_EXPORT Q_DECL_EXPORT
#else
#    define LIBSTYLES_EXPORT Q_DECL_IMPORT
#endif

#endif // LIBSTYLES_GLOBAL_H
