#ifndef PROJ_UTIL_AM_I_BEING_DEBUGGED_H
#define PROJ_UTIL_AM_I_BEING_DEBUGGED_H

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
bool OkToEnableAssertions();

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJ_UTIL_AM_I_BEING_DEBUGGED_H
