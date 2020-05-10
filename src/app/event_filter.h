#ifndef PROJECT_APP_EVENT_FILTER_H
#define PROJECT_APP_EVENT_FILTER_H

#include <QObject>

namespace project
{
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

} // namespace project

#endif // PROJECT_APP_EVENT_FILTER_H
