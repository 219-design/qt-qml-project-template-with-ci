//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#include "resources.h"

#include <QDir>
#include <QQmlEngine>

// Q_INIT_RESOURCE cannot be called from inside a named namespace.  See:
// http://doc.qt.io/qt-5/qdir.html#Q_INIT_RESOURCE
static inline void init()
{
    Q_INIT_RESOURCE( libstyles );
}

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void initLibStylesResources()
{
    init();

    // Any other qregister things we wish...
    // qRegisterMetaType<CustomType*>("CustomType*");
}

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
