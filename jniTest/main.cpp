#include <QApplication>
#include <QQmlApplicationEngine>
#include <QAndroidJniObject>
#include <QDebug>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    int val = 123;
    int retVal = QAndroidJniObject::callStaticMethod<jint>
                ("com/kdab/training/USBCOnnector",
                 "fibonacciJava",
                 "(I)I",
                 val);

    int deviceListVal = QAndroidJniObject::callStaticMethod<jint>
                ("com/kdab/training/USBCOnnector",
                 "printDeviceList",
                 "(I)I",
                 12);

    qDebug() << "Returned " << retVal << " From the fibonacciJava method.";
    qDebug() << "Returned " << deviceListVal << " From the printDeviceList method.";
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
