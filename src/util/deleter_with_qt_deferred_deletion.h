#ifndef PROJ_LIB_UTIL_DELETER_QT_DEFERRED_DELETION_H
#define PROJ_LIB_UTIL_DELETER_QT_DEFERRED_DELETION_H

#include <QObject>

namespace project
{
/*
  Two forms of usage:

  // unique_ptr WITH CUSTOM DELETER
  std::unique_ptr<QLowEnergyController, DeleterWithQtDeferredDeletion> m_controller;
  m_controller.reset( QLowEnergyController::createCentral( m_info ) );

  ------------------------------------------------------------------------------

  std::shared_ptr<DeviceController> result( new DeviceController( alerts, info, listener ),
    // shared_ptr with CUSTOM DELETER:
    DeleterWithQtDeferredDeletion{} );

*/
struct DeleterWithQtDeferredDeletion
{
    void operator()( QObject* p ) const;
};
} // namespace project

#endif // PROJ_LIB_UTIL_DELETER_QT_DEFERRED_DELETION_H
