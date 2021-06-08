//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#include "gui_tests.h"

#include <QCoreApplication>
#include <QTimer>

#include "util-assert.h"

namespace project
{
namespace
{
// Don't let this discourage us from ever renaming our qml filenames. This
// isn't for the purpose of enforcing the precise NAME. Rather, this is used
// only to give confirmation that we understand what the
// QQmlApplicationEngine creates/loads when the app is run.
constexpr char EXPECTED_FIRST_LOADED_FILE[] = "main.qml";
} // namespace

GuiTests::GuiTests( QQmlEngine& engine )
{
    const QQmlApplicationEngine* appEngine
        = dynamic_cast<const QQmlApplicationEngine*>( &engine );
    FASSERT( appEngine, "not null. downcast must succeed." );

    connect( appEngine, &QQmlApplicationEngine::objectCreated, [ = ]( QObject*, const QUrl& url ) {
        FASSERT( url.fileName() == QString( EXPECTED_FIRST_LOADED_FILE ), "something must have changed in loading behavior of QQmlApplicationEngine" );

        // quit during next event-loop cycle
        QTimer::singleShot( 1 /*milliseconds*/, QCoreApplication::instance(), QCoreApplication::quit );
    } );
}

GuiTests::~GuiTests() = default;

} // namespace project
