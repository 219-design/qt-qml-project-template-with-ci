//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "view_model_collection.h"

#include "src/lib/resource_helper.h"
#include "src/lib/resources.h"

namespace project
{
ViewModelCollection::ViewModelCollection()
{
    project::initLibResources();

    // Do after the 'init..resource' calls, in case any ctor wants rsrcs:
    // m_navigation = std::make_unique<Navigation>();
}

ViewModelCollection::~ViewModelCollection() = default;

void ViewModelCollection::ExportContextPropertiesToQml( QQmlEngine* engine )
{
    // m_navigation->ExportContextPropertiesToQml( engine );
    ResourceHelper::ExportContextPropertiesToQml( engine );
}

} // namespace project
