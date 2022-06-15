//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//

#include "lib.h"

namespace project
{
int LibraryFunction()
{
    return 5;
}

int LibraryClass::getValue()
{
    return m_example.ExampleFunction( 10 );
}

} // namespace project
