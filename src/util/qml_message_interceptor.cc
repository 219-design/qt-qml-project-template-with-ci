//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "qml_message_interceptor.h"

#include <QtGlobal>

#include "util-assert.h"

#ifdef _MSC_VER
#    define strcasecmp _stricmp
#endif

namespace project
{
namespace
{
    // QtMessageHandler is a typedef qtbase/src/corelib/global/qlogging.h
    QtMessageHandler original_handler = nullptr;

    bool EndsWith( const char* string_to_search, const char* target_suffix )
    {
        if( !string_to_search || !target_suffix )
        {
            return false;
        }

        // strrchr() returns a pointer to the LAST occurrence of the character
        const char* dot = strrchr( string_to_search, '.' );
        if( dot && !strcasecmp( dot, target_suffix ) )
        {
            return true;
        }

        return false;
    }

    // Treat QML warnings as fatal.
    // Rationale: historically, a majority of QML warnings have indicated bugs.
    void FilterQmlWarnings( const char* file )
    {
        if( EndsWith( file, ".qml" ) || EndsWith( file, ".js" ) )
        {
            FFAIL( "qml warning detected (in *qml or *js file). please fix it." );
        }
    }

    void DecoratorFunction( QtMsgType type, const QMessageLogContext& context,
        const QString& message )
    {
        // always pass through to original Qt handler first:
        original_handler( type, context, message );

        switch( type )
        {
            // debug and info messages don't need special treatment
        case QtDebugMsg:
        case QtInfoMsg:
            break;

            // warnings (and worse) get extra attention
        case QtWarningMsg:
        case QtCriticalMsg:
        case QtFatalMsg:
            FilterQmlWarnings( context.file );
            break;

        default:
            FFAIL( "impossible. there are no other enum values to test for" );
        }
    }

} // namespace

QmlMessageInterceptor::QmlMessageInterceptor()
{
    FASSERT( original_handler == nullptr, "Qt supports just one handler at a time, so it would be an error to construct more than one of these" );
    original_handler = qInstallMessageHandler( DecoratorFunction );
}

QmlMessageInterceptor::~QmlMessageInterceptor()
{
    FASSERT( original_handler, "should be impossible for this to be null here" );
    qInstallMessageHandler( original_handler );
    original_handler = nullptr;
}

} // namespace project
