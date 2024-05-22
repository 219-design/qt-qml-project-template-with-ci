#include "deleter_with_qt_deferred_deletion.h"

#include <QDebug>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
void DeleterWithQtDeferredDeletion::operator()( QObject* p ) const
{
    qInfo() << "deleteLater reached on an instance of:" << p->metaObject()->className();
    // per Qt docs: when the first deferred deletion event is delivered, any
    // pending events for the object are removed from the event queue.
    p->deleteLater();
}
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
