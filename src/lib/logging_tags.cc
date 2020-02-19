//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "logging_tags.h"

#include <QtQml/QQmlContext>

#include "src/lib/cli_options.h"

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
}

QString LoggingTags::GuiTestingLogTag() const
{
    return GUI_TEST_LOG_TAG; // exposed as a Q_PROPERTY
}

} // namespace project
