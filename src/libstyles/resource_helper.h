//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJ_LIB_RESOURCE_HELPER_H
#define PROJ_LIB_RESOURCE_HELPER_H

#include <QtCore/QObject>
#include <QtQml/QQmlEngine>

#include "libstyles_global.h"

namespace project
{
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

} // namespace project

#endif // PROJ_LIB_RESOURCE_HELPER_H
