//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJ_LIBSTYLES_RESOURCES_H
#define PROJ_LIBSTYLES_RESOURCES_H

#include "libstyles_global.h"

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void LIBSTYLES_EXPORT initLibStylesResources();
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJ_LIBSTYLES_RESOURCES_H
