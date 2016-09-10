#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QDebug>
#include <QAndroidJniObject>
//#include <Python.h>

QT_USE_NAMESPACE

int fib(int n)
{
   return QAndroidJniObject::callStaticMethod<jint>
           ("com/interface/usb",
            "fibonacci",
            "(I)I",
            n);
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    //Py_Initialize();
    qDebug() << "JNI function Fib says "<< fib(20);
    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts())
    {
            qDebug() << "Name : " << info.portName();
            qDebug() << "Description : " << info.description();
            qDebug() << "Manufacturer: " << info.manufacturer();


            if(info.description() == "CANtact dev")
            {
                qDebug() << "Description matched.";
                QSerialPort serial;
                serial.setPort(info);
                qDebug() << "Serial object created";
                if(serial.open(QIODevice::ReadWrite))
                {
                    qDebug() << "We have opened the port!!";
                    serial.close();
                }
            }
    }
    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));

    return app.exec();

    //Py_Finalize();
}
