//
// Copyright (c) 2020, 219 Design, LLC
// See LICENSE.txt
//
// https://www.219design.com
// Software | Electrical | Mechanical | Product Design
//
#ifndef PROJECT_APP_QML_MESSAGE_INTERCEPTOR_H
#define PROJECT_APP_QML_MESSAGE_INTERCEPTOR_H

#include <QObject>

#include <functional>
#include <memory>
#include <vector>

namespace project
{
class QmlMessageInterceptor
{
public:
    explicit QmlMessageInterceptor( bool suppressDefaultLogWhenSinkIsPresent );

    void AddMessageSink(
        std::weak_ptr<std::function<void( QtMsgType type, const QMessageLogContext& context, const QString& message )>>
            sink );

    ~QmlMessageInterceptor();

    struct Pimpl; // "effectively private" due to no definition.
    friend struct Pimpl; // thusly, Pimpl provides access to private data
private:
    void DecoratorFunction( QtMsgType type, const QMessageLogContext& context, const QString& message );
    int TeeToSinks( QtMsgType type, const QMessageLogContext& context, const QString& message );
    void CullDeadSinks();

    Pimpl* const m_pimpl;
    const bool m_suppressDefaultLogWhenSinkIsPresent;
    std::vector<
        std::weak_ptr<std::function<void( QtMsgType type, const QMessageLogContext& context, const QString& message )>>>
        m_sinks;
};

} // namespace project

#endif // PROJECT_APP_QML_MESSAGE_INTERCEPTOR_H
