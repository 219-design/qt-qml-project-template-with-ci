//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "view_model_collection.h"

int main( int argc, char* argv[] )
{
    QGuiApplication app( argc, argv );

    // ViewModels must OUTLIVE the qml engine, so create them first:
    project::ViewModelCollection vms( app );

    // Created after vms, so that we avoid null vm qml warnings upon vm dtors
    QQmlApplicationEngine engine;

    vms.ExportContextPropertiesToQml( &engine );

    engine.addImportPath( "qrc:///" ); // needed for finding qml in our plugins
    engine.load( QUrl( QStringLiteral( "qrc:///qml/homepage.qml" ) ) );

    return app.exec();
}
