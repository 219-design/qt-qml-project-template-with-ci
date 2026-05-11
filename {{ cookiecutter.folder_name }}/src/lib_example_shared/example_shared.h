#ifndef PROJ_LIB_EXAMPLE_SHARED_EXAMPLE_SHARED_H
#define PROJ_LIB_EXAMPLE_SHARED_EXAMPLE_SHARED_H

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
class ExampleClass
{
public:
    int ExampleFunction( int arg ) const;
};

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJ_LIB_EXAMPLE_SHARED_EXAMPLE_SHARED_H