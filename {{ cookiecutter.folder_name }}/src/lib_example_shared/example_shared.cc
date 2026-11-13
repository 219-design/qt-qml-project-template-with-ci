#include "example_shared.h"

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
int ExampleClass::ExampleFunction( int arg ) const
{
    return arg + 5;
}

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
