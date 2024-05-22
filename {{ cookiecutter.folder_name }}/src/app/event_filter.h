#ifndef PROJECT_APP_EVENT_FILTER_H
#define PROJECT_APP_EVENT_FILTER_H

#include <QObject>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
class EventFilter : public QObject
{
    Q_OBJECT
public:
    explicit EventFilter();
    ~EventFilter();

    void FilterEventsDirectedAtThisObject( QObject* eventsSource );

protected:
    // return true if the event should be filtered (i.e. stopped)
    bool eventFilter( QObject* obj, QEvent* event ) override;

    // We can assume next to NOTHING about the lifetime of m_eventsSource. (see other comments in cc file)
    QObject* m_eventsSource = nullptr;
};

{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}

#endif // PROJECT_APP_EVENT_FILTER_H
