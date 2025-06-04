//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#ifndef PROJ_LIB_RESOURCE_HELPER_H
#define PROJ_LIB_RESOURCE_HELPER_H

#include <QtCore/QObject>
#include <QtQml/QQmlEngine>

#include "libstyles_global.h"

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
class LIBSTYLES_EXPORT ResourceHelper : public QObject
{
    Q_OBJECT

    // Should correspond to content in qml/dummydata/resourceHelper.qml
    Q_PROPERTY( QString imageSourcePrefix MEMBER imageSourcePrefix CONSTANT )

public:
    ResourceHelper() = default;
    ~ResourceHelper() override = default;

    ResourceHelper( const ResourceHelper& ) = delete;
    ResourceHelper& operator=( const ResourceHelper& ) = delete;

    static void ExportContextPropertiesToQml( QQmlEngine* engine );

    // Should correspond to content in qml/dummydata/resourceHelper.qml
    const QString imageSourcePrefix = "qrc:///libstyles/";
};

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJ_LIB_RESOURCE_HELPER_H
