//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJECT_APP_GUI_TESTS_H
#define PROJECT_APP_GUI_TESTS_H

#include <QQmlApplicationEngine>
#include <QtCore/QObject>

namespace project
{
class GuiTests : public QObject
{
    Q_OBJECT
public:
    explicit GuiTests( QQmlEngine& qmlapp );
    ~GuiTests();

    GuiTests( const GuiTests& ) = delete;
    GuiTests& operator=( const GuiTests& ) = delete;
};
} // namespace project

#endif // PROJECT_APP_GUI_TESTS_H
