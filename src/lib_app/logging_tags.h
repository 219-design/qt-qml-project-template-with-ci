//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJECT_LIB_LOGGING_TAGS_H
#define PROJECT_LIB_LOGGING_TAGS_H

#include <QLoggingCategory>
#include <QtCore/QObject>
#include <QtQml/QQmlEngine>

namespace project
{
class CliOptions;

// Qt uses the terminology "logging categories" to refer to what other
// frameworks call "trace masks". Either way, these kinds of terms refer to the
// ability to tag or mark each log statement with some kind of extra type
// marker, so that you can later dynamically suppress or unsuppress only certain
// types of log messages on a fine-grained level.
//
// Our LoggingTags class exists to provide a "single source of truth" for the
// hardcoded string labels that we can use as qt log categories from either QML
// (using QML LoggingCategory) or from C++
class LoggingTags : public QObject
{
    Q_OBJECT

    // clang-format off

    // Using a function instead of MEMBER CONSTANT so that C++ code has a way to retrieve it, too.
    Q_PROPERTY( QString guiTestingLogTag
                READ GuiTestingLogTag
                NOTIFY EventGuiTestingLogTagChanged )
    // clang-format on

public:
    explicit LoggingTags( const CliOptions& options );
    ~LoggingTags() override;

    LoggingTags( const LoggingTags& ) = delete;
    LoggingTags& operator=( const LoggingTags& ) = delete;

    void ExportContextPropertiesToQml( QQmlEngine* engine );

    QString GuiTestingLogTag() const;

    // Feel free to move this to some other utility/helper viewModel.
    // It was added to LoggingTags at a time when LoggingTags was the only
    // object in the base template repository that implemented ExportContextPropertiesToQml
    Q_INVOKABLE void handleMobileLink( const QString& emailSubj );

signals:
    void EventGuiTestingLogTagChanged();
};

Q_DECLARE_LOGGING_CATEGORY( guiTests ) // Make this match up with LogTags.qml
} // namespace project

#endif // PROJECT_LIB_LOGGING_TAGS_H
