//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//

#ifndef PROJ_LIB_LIB_H
#define PROJ_LIB_LIB_H

#include <QObject>

#include "src/lib_app/quarantined_awaiting_warning_fixes.h" // present for sake of demonstration
#include "src/lib_example_shared/example_shared.h"

namespace project
{
int LibraryFunction();

class LibraryClass : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE int getValue();

private:
    ExampleClass m_example;
};

} // namespace project

#endif // PROJ_LIB_LIB_H
