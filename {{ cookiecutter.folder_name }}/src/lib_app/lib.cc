//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//

#include "lib.h"

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
int LibraryFunction()
{
    return 5;
}

int LibraryClass::getValue()
{
    return m_example.ExampleFunction( 10 );
}

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
