//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "lib/lib.h"
#include "lib/resources.h"

int main( int argc, char* argv[] )
{
    project::initLibResources();

    QGuiApplication app( argc, argv );

    QQmlApplicationEngine engine;
    engine.addImportPath( "qrc:///" ); // needed for finding qml in our plugins
    engine.load( QUrl( QStringLiteral( "qrc:///qml/homepage.qml" ) ) );

    return app.exec();
}
