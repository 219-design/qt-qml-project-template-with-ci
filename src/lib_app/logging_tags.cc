//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "logging_tags.h"

#include <QDebug>
#include <QtQml/QQmlContext>

#include "src/lib_app/cli_options.h"

#ifdef Q_OS_ANDROID
#    include "src/lib_app/android/intent_to_email.cc"
#endif // Q_OS_ANDROID

namespace project
{
// refer to comments in our header file to see why we store this string here
constexpr char GUI_TEST_LOG_TAG[] = "thisapp.guitesting";

Q_LOGGING_CATEGORY( guiTests, GUI_TEST_LOG_TAG )

LoggingTags::LoggingTags( const CliOptions& options )
{
    if( options.RunningGuiTests() )
    {
        QLoggingCategory::setFilterRules( QString( GUI_TEST_LOG_TAG ) + "=true" );
    }
    else
    {
        QLoggingCategory::setFilterRules( QString( GUI_TEST_LOG_TAG ) + "=false" );
    }

    // Example of using our category in C++ code.
    // (This will only print when RunningGuiTests() is true:
    qCInfo( guiTests, "Example of using our custom category in cc code." );
}

LoggingTags::~LoggingTags() = default;

void LoggingTags::ExportContextPropertiesToQml( QQmlEngine* engine )
{
    // refer to the comments in our header file to understand why we do this
    engine->rootContext()->setContextProperty( "customLoggingCategories", this );
    qDebug() << "Exported customLoggingCategories";
}

QString LoggingTags::GuiTestingLogTag() const
{
    return GUI_TEST_LOG_TAG; // exposed as a Q_PROPERTY
}

void LoggingTags::handleMobileLink( const QString& emailSubj )
{
#ifdef Q_OS_ANDROID
    // no built-in qt thing we tried would succeed in opening an email client on android,
    // so we rolled our own:
    AndroidHandleMobileLink( emailSubj, "body text here" );
#else
    (void) emailSubj;
    qWarning() << "handleMobileLink needs an IMPLEMENTATION. Currently does nothing.";
    // on platforms other than android, you can construct a mailto link and use:
    //    QDesktopServices::openUrl( link );
#endif // Q_OS_ANDROID
}
} // namespace project
