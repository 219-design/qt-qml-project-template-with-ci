//
// Copyright (c) {{ cookiecutter.year }}, {{ cookiecutter.who_am_I }} ({{ cookiecutter.email }})
// See LICENSE.txt
//
// {{ cookiecutter.website }}
//
#ifndef PROJECT_APP_QML_MESSAGE_INTERCEPTOR_H
#define PROJECT_APP_QML_MESSAGE_INTERCEPTOR_H

#include <QObject>

#include <functional>
#include <memory>
#include <vector>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
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

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJECT_APP_QML_MESSAGE_INTERCEPTOR_H
