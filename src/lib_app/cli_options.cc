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
constexpr char COLOR_PALETTE_CLI_OPT[] = "colorpalette";

CliOptions::CliOptions( const QCoreApplication& app, bool stopAtParseOnly )
{
    QCommandLineParser parser;
    parser.addHelpOption();

    parser.addOptions( {
        { { "g", GUI_TEST_CLI_OPT }, "run automated gui tests (app will SHUT DOWN soon after launch)" },
        { { "v", MAX_QT_LOGGING_CLI_OPT },
            "verbose/maximum logging. uses Qt stderr log even when also tee-ing to backend file log" },
        { { "c", COLOR_PALETTE_CLI_OPT }, "show color palette to allow for on-the-fly color experiments" },
    } );

    if( !stopAtParseOnly )
    {
        // The NOT-stop case is the full desktop application.
        // This call to 'process' gives us parsing and type-checking and error
        // reporting. (In other words, everything you would want in a full app.)
        parser.process( app );
    }
    else
    {
        // The 'stopAtParseOnly' case is the case when this instance of
        // CliOptions is part of our 'lightly hacked' and 'project aware'
        // locally-built qmlscene.
        //    We MUST NOT CALL QCommandLineParser::process IN THIS CASE, because
        // it will prevent us from using the arguments that qmlscene accepts in
        // its own 'main' function.
        //    By calling 'parse' instead, we DO achieve the desired capture of
        // our app-specific options. As a trade-off, we forgo the built-in
        // type-checking and error reporting of QCommandLineParser::process
        const QStringList arguments = QCoreApplication::arguments();
        parser.parse( arguments );
    }

    m_guiTests = parser.isSet( GUI_TEST_CLI_OPT );
    m_maximumQtLogs = parser.isSet( MAX_QT_LOGGING_CLI_OPT );
    m_colorPalette = parser.isSet( COLOR_PALETTE_CLI_OPT );
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

bool CliOptions::ShowColorPalette() const
{
    return m_colorPalette;
}

} // namespace project
