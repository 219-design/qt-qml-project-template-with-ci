//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#ifndef PROJ_LIB_RESOURCES_H
#define PROJ_LIB_RESOURCES_H

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void initLibResources();

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJ_LIB_RESOURCES_H
