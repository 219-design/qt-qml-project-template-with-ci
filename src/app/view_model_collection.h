//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJECT_APP_VIEW_MODEL_COLLECTION_H
#define PROJECT_APP_VIEW_MODEL_COLLECTION_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>

#include <memory>

namespace project
{
class CliOptions;
class EventFilter;
class GuiTests;
class LibraryClass;
class LoggingTags;
class QmlMessageInterceptor;

class ViewModelCollection
{
public:
    explicit ViewModelCollection( const QCoreApplication& app, bool cliArgsOnlyParseThenSkipErrorHandling );
    ~ViewModelCollection();

    ViewModelCollection( const ViewModelCollection& ) = delete;
    ViewModelCollection& operator=( const ViewModelCollection& ) = delete;

    void ExportContextPropertiesToQml( QQmlEngine* engine );

    void SetRootObject( QObject* object );

    const CliOptions& Options() const;

private:
    std::unique_ptr<const CliOptions> m_opts;
    std::unique_ptr<EventFilter> m_eventFilter;
    std::unique_ptr<QmlMessageInterceptor> m_qmlLogger;
    std::unique_ptr<LoggingTags> m_logging;

    std::unique_ptr<LibraryClass> m_libraryClass;

    std::unique_ptr<GuiTests> m_guiTests;
};
} // namespace project

#endif // PROJECT_APP_VIEW_MODEL_COLLECTION_H
