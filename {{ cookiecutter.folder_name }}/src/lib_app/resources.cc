//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#include "resources.h"

#include <QDir>

#include "src/libstyles/resources.h"

// Q_INIT_RESOURCE cannot be called from inside a named namespace.  See:
// http://doc.qt.io/qt-5/qdir.html#Q_INIT_RESOURCE
static inline void init()
{
    Q_INIT_RESOURCE( libresources );
}

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void initLibResources()
{
    init();
    {{ cookiecutter.cpp_namespace | replace('.', '::') }}::initLibStylesResources();

    // Any other qregister things we wish...
    // qRegisterMetaType<CustomType*>("CustomType*");
}

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
