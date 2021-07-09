#include <QDebug>
#include <QString>
#include <QtAndroidExtras/QAndroidIntent>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QtAndroidExtras/QtAndroid>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
namespace
{
void AndroidHandleMobileLink( const QString& subj, const QString& bod )
{
    const QAndroidJniObject subject = QAndroidJniObject::fromString( subj );
    const QAndroidJniObject body = QAndroidJniObject::fromString( bod );

    // To discover the correct JNI signature string, do:
    //   javap -s classes/com/mycompany/myapp/MyAppActivity.class
    QAndroidJniObject::callStaticMethod<void>(
        "com/mycompany/myapp/MyAppActivity",
        "sendMailWithSubject",
        "(Ljava/lang/String;Ljava/lang/String;)V",
        subject.object<jstring>(),
        body.object<jstring>() );
    return;
}
} // namespace
{% for ns in nslist %}
} // namespace {{ ns }}
{% endfor %}
