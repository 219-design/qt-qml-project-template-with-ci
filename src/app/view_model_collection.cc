//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "view_model_collection.h"

#include "gui_tests.h"
#include "qml_message_interceptor.h"
#include "src/lib/cli_options.h"
#include "src/lib/logging_tags.h"
#include "src/lib/resource_helper.h"
#include "src/lib/resources.h"

namespace project
{
ViewModelCollection::ViewModelCollection( const QGuiApplication& app )
    : m_opts( std::make_unique<CliOptions>( app ) ), m_qmlLogger( std::make_unique<QmlMessageInterceptor>() ), m_logging( std::make_unique<LoggingTags>( *m_opts ) )
{
    project::initLibResources();

    // Do after the 'init..resource' calls, in case any ctor wants rsrcs:
    // m_navigation = std::make_unique<Navigation>();
}

ViewModelCollection::~ViewModelCollection() = default;

void ViewModelCollection::ExportContextPropertiesToQml( QQmlApplicationEngine* engine )
{
    // m_navigation->ExportContextPropertiesToQml( engine );
    m_logging->ExportContextPropertiesToQml( engine );
    ResourceHelper::ExportContextPropertiesToQml( engine );

    // Keep this at the END of the 'ExportContext...' method, so all view models are exported before any tests run
    if( m_opts->RunningGuiTests() )
    {
        m_guiTests = std::make_unique<GuiTests>( *engine );
    }
}

} // namespace project
