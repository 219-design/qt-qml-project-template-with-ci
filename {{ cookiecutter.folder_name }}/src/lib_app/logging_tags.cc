//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#include "logging_tags.h"

#include <QDebug>
#include <QtQml/QQmlContext>

#include "src/lib_app/cli_options.h"

#ifdef Q_OS_ANDROID
#    include "src/lib_app/android/intent_to_email.cc"
#endif // Q_OS_ANDROID

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
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
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
