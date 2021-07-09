//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#ifndef PROJECT_APP_CLI_OPTIONS_H
#define PROJECT_APP_CLI_OPTIONS_H

#include <QCoreApplication>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
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
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJECT_APP_CLI_OPTIONS_H
