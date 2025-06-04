//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#include "resource_helper.h"

#include <QtQml/QQmlContext>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
namespace
{
ResourceHelper helper;
} // namespace

/*static*/ void ResourceHelper::ExportContextPropertiesToQml( QQmlEngine* engine )
{
    engine->rootContext()->setContextProperty( "resourceHelper", &helper );
}

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
