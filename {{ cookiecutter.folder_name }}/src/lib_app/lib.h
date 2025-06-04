//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//

#ifndef PROJ_LIB_LIB_H
#define PROJ_LIB_LIB_H

#include <QObject>

#include "src/lib_app/quarantined_awaiting_warning_fixes.h" // present for sake of demonstration
#include "src/lib_example_shared/example_shared.h"

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
int LibraryFunction();

class LibraryClass : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE int getValue();

private:
    ExampleClass m_example;
};

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJ_LIB_LIB_H
