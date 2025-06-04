//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#ifndef PROJECT_APP_GUI_TESTS_H
#define PROJECT_APP_GUI_TESTS_H

#include <QQmlApplicationEngine>
#include <QtCore/QObject>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
class GuiTests : public QObject
{
    Q_OBJECT
public:
    explicit GuiTests( QQmlEngine& qmlapp );
    ~GuiTests();

    GuiTests( const GuiTests& ) = delete;
    GuiTests& operator=( const GuiTests& ) = delete;
};
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJECT_APP_GUI_TESTS_H
