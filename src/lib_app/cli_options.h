//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJECT_APP_CLI_OPTIONS_H
#define PROJECT_APP_CLI_OPTIONS_H

#include <QCoreApplication>

namespace project
{
class CliOptions
{
public:
    explicit CliOptions( const QCoreApplication& app, bool stopAtParseOnly );
    ~CliOptions();

    CliOptions( const CliOptions& ) = delete;
    CliOptions& operator=( const CliOptions& ) = delete;

    bool RunningGuiTests() const;
    bool MaximumQtLogging() const;
    bool ShowColorPalette() const;

private:
    bool m_guiTests = false;
    bool m_maximumQtLogs = false;
    bool m_colorPalette = false;
};
} // namespace project

#endif // PROJECT_APP_CLI_OPTIONS_H
