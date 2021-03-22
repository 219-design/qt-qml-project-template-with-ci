#include "deleter_with_qt_deferred_deletion.h"

#include <QDebug>

namespace project
{
void DeleterWithQtDeferredDeletion::operator()( QObject* p ) const
{
    qInfo() << "deleteLater reached on an instance of:" << p->metaObject()->className();
    // per Qt docs: when the first deferred deletion event is delivered, any
    // pending events for the object are removed from the event queue.
    p->deleteLater();
}
} // namespace project
