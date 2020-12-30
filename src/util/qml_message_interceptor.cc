//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "qml_message_interceptor.h"

#include <QCoreApplication>
#include <QFileInfo>
#include <QStandardPaths>
#include <QtGlobal>

#include "util-assert.h"

#ifdef _MSC_VER
#    define strcasecmp _stricmp
#endif

namespace project
{
struct QmlMessageInterceptor::Pimpl // "effectively private" due to no definition in header, but provides full access to
    // Interceptor
{
    explicit Pimpl( QmlMessageInterceptor* o )
        : owner( o )
    {
        FASSERT( owner, "cannot be nullptr" );
    }

    void DecoratorFunc( QtMsgType type, const QMessageLogContext& context, const QString& message )
    {
        owner->DecoratorFunction( type, context, message ); // pass through to PRIVATE method of interceptor.
    }

    QmlMessageInterceptor* const owner;
};
namespace
{
// QtMessageHandler is a typedef qtbase/src/corelib/global/qlogging.h
QtMessageHandler original_handler = nullptr;
QmlMessageInterceptor::Pimpl* our_interceptor = nullptr;

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

    const char* fslash = strrchr( string_to_search, '/' );
    if( fslash && !strcasecmp( fslash, target_suffix ) )
    {
        return true;
    }

    return false;
}

bool IndividualWarningIsMarkedAsIgnored( const QString& currentLogMessage )
{
    static bool didLazyLoad = false;
    static QStringList ignoredMessages;

    if( didLazyLoad == false )
    {
        didLazyLoad = true;
        const QString tmp = QStandardPaths::writableLocation( QStandardPaths::TempLocation );
        const QFileInfo fileInfo( tmp + "/" + QCoreApplication::applicationName() + "_qml_suppressed_warnings.txt" );
        const bool fileOk = fileInfo.exists() && fileInfo.isReadable() && fileInfo.isFile() && fileInfo.size() > 0 && fileInfo.size() < 100000;

        if( !fileOk )
        {
            // Note: do not log this with Qt logging, since we are currently
            // IN A HANDLER PROCESSING Qt logging.
            fprintf( stderr, "qml_message_interceptor found no usable suppressions in: %s\n", fileInfo.absoluteFilePath().toStdString().c_str() );
        }
        else
        {
            QFile suppressions( fileInfo.absoluteFilePath() );
            if( suppressions.open( QIODevice::ReadOnly ) )
            {
                while( !suppressions.atEnd() )
                {
                    const auto candidate = suppressions.readLine().trimmed();
                    if( candidate.length() < 3 )
                    {
                        fprintf( stderr, "qml_message_interceptor rejected vague suppression: %s\n",
                            candidate.toStdString().c_str() );
                    }
                    else
                    {
                        ignoredMessages.append( candidate );
                    }
                }
            }

            // Note: do not log this with Qt logging, since we are currently
            // IN A HANDLER PROCESSING Qt logging.
            fprintf( stderr, "qml_message_interceptor applied %d usable suppression(s) in: %s\n",
                static_cast<int>( ignoredMessages.count() ), fileInfo.absoluteFilePath().toStdString().c_str() );
        }
    }

    for( const auto& ignored : ignoredMessages )
    {
        // Intentionally not supporting regexes or other complexity.
        // Would prefer to NOT be responsible for thinking through regex edge cases.
        if( currentLogMessage.contains( ignored, Qt::CaseSensitive ) )
        {
            // Note: do not log this with Qt logging, since we are currently
            // IN A HANDLER PROCESSING Qt logging.
            fprintf( stderr, "IGNORED_WARNING: %s\n", currentLogMessage.toStdString().c_str() );
            return true;
        }
    }

    return false;
}

// Treat QML warnings as fatal.
// Rationale: historically, a majority of QML warnings have indicated bugs.
void FilterQmlWarnings( const char* file, const QString& message )
{
    // NOTE: when using Qt RELEASE libraries (not debug), it may be
    // IMPOSSIBLE to ever match on '/qqmlapplicationengine.cpp' because they
    // seem to strip out file info (it shows "unknown") for the filename in
    // certain RELEASE/optimized qt builds.
    if( EndsWith( file, ".qml" ) || EndsWith( file, ".js" ) || EndsWith( file, "/qqmlapplicationengine.cpp" ) )
    {
        if( !IndividualWarningIsMarkedAsIgnored( message ) )
        {
            FFAIL( "qml warning detected (in *qml or *js file). please fix it." );
        }
    }
}

void DecoratorFunc( QtMsgType type, const QMessageLogContext& context, const QString& message )
{
    FASSERT( our_interceptor, "you must assign to our_interceptor before we get here" );
    our_interceptor->DecoratorFunc( type, context, message );
}

} // namespace

QmlMessageInterceptor::QmlMessageInterceptor( const bool suppressDefaultLogWhenSinkIsPresent )
    : m_pimpl( new Pimpl( this ) ), m_suppressDefaultLogWhenSinkIsPresent( suppressDefaultLogWhenSinkIsPresent )
{
    FASSERT( original_handler == nullptr,
        "Qt supports just one handler at a time, so it would be an error to construct more than one of these" );
    FASSERT( our_interceptor == nullptr,
        "Qt supports just one handler at a time, so it would be an error to construct more than one of these" );
    our_interceptor = m_pimpl;
    original_handler = qInstallMessageHandler( DecoratorFunc );
}

QmlMessageInterceptor::~QmlMessageInterceptor()
{
    FASSERT( original_handler, "should be impossible for this to be null here" );
    qInstallMessageHandler( original_handler );
    original_handler = nullptr;
    delete m_pimpl;
}

void QmlMessageInterceptor::AddMessageSink(
    std::weak_ptr<std::function<void( QtMsgType type, const QMessageLogContext& context, const QString& message )>>
        sink )
{
    m_sinks.push_back( sink );
}

void QmlMessageInterceptor::DecoratorFunction(
    QtMsgType type, const QMessageLogContext& context, const QString& message )
{
    const int activeTees = TeeToSinks( type, context, message );

    if( 0 == activeTees || !m_suppressDefaultLogWhenSinkIsPresent )
    {
        // pass through to original Qt handler:
        original_handler( type, context, message );
    }

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
        FilterQmlWarnings( context.file, message );
        break;

    default:
        FFAIL( "impossible. there are no other enum values to test for" );
    }
}

int QmlMessageInterceptor::TeeToSinks( QtMsgType type, const QMessageLogContext& context, const QString& message )
{
    int sinksThatWereLoggedTo = 0;
    for( auto& sink : m_sinks )
    {
        auto p = sink.lock();
        if( p && ( *p ) )
        {
            ( *p )( type, context, message );
            sinksThatWereLoggedTo++;
        }
    }
    CullDeadSinks();

    return sinksThatWereLoggedTo;
}

void QmlMessageInterceptor::CullDeadSinks()
{
    using weakPtr = std::weak_ptr<
        std::function<void( QtMsgType type, const QMessageLogContext& context, const QString& message )>>;
    m_sinks.erase(
        std::remove_if( m_sinks.begin(), m_sinks.end(), []( weakPtr sinkPtr ) { return sinkPtr.expired(); } ),
        m_sinks.end() );
}

} // namespace project
