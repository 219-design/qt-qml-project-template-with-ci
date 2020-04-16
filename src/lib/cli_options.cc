//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "cli_options.h"

#include <QCommandLineParser>

namespace project
{
constexpr char GUI_TEST_CLI_OPT[] = "guitest";
constexpr char MAX_QT_LOGGING_CLI_OPT[] = "maxlogs";

CliOptions::CliOptions( const QCoreApplication& app )
{
    QCommandLineParser parser;
    parser.addHelpOption();

    parser.addOptions( {
        {{"g", GUI_TEST_CLI_OPT}, "run automated gui tests (app will SHUT DOWN soon after launch)"},
        {{"v", MAX_QT_LOGGING_CLI_OPT},
            "verbose/maximum logging. uses Qt stderr log even when also tee-ing to backend file log"},
    } );

    parser.process( app );

    m_guiTests = parser.isSet( GUI_TEST_CLI_OPT );
    m_maximumQtLogs = parser.isSet( MAX_QT_LOGGING_CLI_OPT );
}

CliOptions::~CliOptions() = default;

bool CliOptions::RunningGuiTests() const
{
    return m_guiTests;
}

bool CliOptions::MaximumQtLogging() const
{
    return m_maximumQtLogs;
}
} // namespace project
