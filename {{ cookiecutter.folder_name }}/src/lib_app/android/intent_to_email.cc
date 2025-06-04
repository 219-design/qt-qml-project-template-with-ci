#include <QDebug>
#include <QJniObject>
#include <QString>
#include <QtCore/private/qandroidextras_p.h>

{% set nslist = cookiecutter.cpp_namespace.split('::') %}
{% for ns in nslist %}
namespace {{ ns }}
{
{% endfor %}
namespace
{
void AndroidHandleMobileLink( const QString& subj, const QString& bod )
{
    const QJniObject subject = QJniObject::fromString( subj );
    const QJniObject body = QJniObject::fromString( bod );

    // To discover the correct JNI signature string, do:
    //   javap -s classes/com/mycompany/myapp/MyAppActivity.class
    QJniObject::callStaticMethod<void>(
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
