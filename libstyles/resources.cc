//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
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

namespace project
{
void initLibStylesResources()
{
    init();

    // Any other qregister things we wish...
    // qRegisterMetaType<CustomType*>("CustomType*");
}

} // namespace project
