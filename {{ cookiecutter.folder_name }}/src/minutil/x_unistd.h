#ifndef PROJ_LIB_MINUTIL_XUNISTD_H
#define PROJ_LIB_MINUTIL_XUNISTD_H

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void MilliSleep( int ms );

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // #ifndef PROJ_LIB_MINUTIL_XUNISTD_H
