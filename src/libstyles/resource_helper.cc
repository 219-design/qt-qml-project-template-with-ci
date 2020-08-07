//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "resource_helper.h"

#include <QtQml/QQmlContext>

namespace project
{
namespace
{
ResourceHelper helper;
} // namespace

/*static*/ void ResourceHelper::ExportContextPropertiesToQml( QQmlEngine* engine )
{
    engine->rootContext()->setContextProperty( "resourceHelper", &helper );
}

} // namespace project
