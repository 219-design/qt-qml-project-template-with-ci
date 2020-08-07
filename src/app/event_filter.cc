#include "event_filter.h"

#include <QDebug>
#include <QEvent>
#include <QKeyEvent>

#include <vector>

#include "src/util/every_so_often.h"
#include "util-assert.h"

namespace project
{
namespace
{
constexpr std::chrono::seconds EVENTLOG_RATELIMIT_PERIOD( 10 );

// clang-format off
    const std::vector<QEvent::Type> WATCHED_TYPES{{
        // Just a mostly arbitrary set of events that help demonstrate that the
        // application event loops is running without fail.
        // (We could also create our own never-ending timer to constantly ping
        //  into our handler, but that is overkill for now. We just want to
        //  lightly monitor what already is going on without adding artificial
        //  goings-on.)
        QEvent::Timer,
        QEvent::MouseButtonPress,
        QEvent::MouseButtonRelease,
        QEvent::KeyPress,
        QEvent::KeyRelease,
        QEvent::Paint,
        QEvent::Show,
        QEvent::WindowActivate,
        QEvent::WindowDeactivate,
        QEvent::MetaCall,
        QEvent::Polish,
        QEvent::LayoutRequest,
        QEvent::TabletPress,
        QEvent::TabletRelease,
        QEvent::GraphicsSceneResize,
        QEvent::GraphicsSceneMove,
        QEvent::Expose
    }};
// clang-format on
} // namespace

EventFilter::EventFilter() = default;

EventFilter::~EventFilter() = default;

void EventFilter::FilterEventsDirectedAtThisObject( QObject* eventsSource )
{
    FASSERT( nullptr == m_eventsSource, "we have ONLY TESTED this with one setter call per object" );
    // We can assume almost NOTHING about the LIFETIME of m_eventsSource.
    // We do NOT own this pointer, and the QObject could be destroyed "at any time."
    // What we DO assume is that if 'eventFilter' is called then the event source must still exist.
    m_eventsSource = eventsSource;
    m_eventsSource->installEventFilter( this );
}

// return true if the event should be filtered (i.e. stopped)
bool EventFilter::eventFilter( QObject* obj, QEvent* event )
{
    FASSERT( m_eventsSource, "if events are coming in, we MUST have a m_eventsSource" );

    int index = -1;
    for( const auto type : WATCHED_TYPES )
    {
        index++;
        if( event->type() == type )
        {
            static EverySoOften logEventsNoMoreThanOncePerN( EVENTLOG_RATELIMIT_PERIOD );
            logEventsNoMoreThanOncePerN.Do( [ index ]() {
                qInfo() << "this GUI thread is running unblocked. Just got event from our index:" << index;
            } );
        }
    }

    if( event->type() >= QEvent::User )
    {
        // We don't have any user-defined events in the application (as of May 1, 2020).
        // So this is here as a just-in-case (could be useful debug info for the future).
        static EverySoOften logUserTypesNoMoreThanOncePerN( EVENTLOG_RATELIMIT_PERIOD );
        logUserTypesNoMoreThanOncePerN.Do( [ event ]() {
            qInfo() << "this GUI thread is processing a user-defined event of type:"
                    << static_cast<int>( event->type() );
        } );
    }

    // The object must match m_eventsSource, or else we react to DUPLICATE
    // events. (This happens because we come through here multiple times for
    // every event, since the same event "bubbles up" through child objects of
    // our m_eventsSource object, and all the bubbling comes through here for
    // each child object in the chain.)
    if( event->type() == QEvent::KeyPress && obj == m_eventsSource )
    {
        QKeyEvent* keyEvent = dynamic_cast<QKeyEvent*>( event );
        FASSERT( keyEvent, "can this ever fail to downcast? we expect not!" );
        (void) keyEvent;
    }

    return QObject::eventFilter( obj, event );
}
} // namespace project
