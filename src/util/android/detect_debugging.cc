#include <QDebug>
#include <QJniObject>
#include <QString>

namespace project
{
namespace
{
bool AndroidDebuggerConnected()
{
    // To discover the correct JNI signature string, do:
    //   javap -s classes/com/mycompany/myapp/MyAppActivity.class
    const auto jbool = QJniObject::callStaticMethod<jboolean>(
        "com/mycompany/myapp/MyAppActivity",
        "isAndroidDebuggerConnected",
        "()Z" );
    qInfo() << "Jni call to isAndroidDebuggerConnected returned" << jbool;
    return static_cast<bool>( jbool );
}
} // namespace
} // namespace project
