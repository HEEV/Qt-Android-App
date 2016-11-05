#ifndef USB_INTERFACE_H
#define USB_INTERFACE_H

//QT libs.
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QFile>
#include <QTextStream>
#include <QByteArray>
#include <QDebug>
#include <QDateTime>
#include <QObject>

//Standard C++ library
#include <string>
#include <iostream>
#include <sstream>

/*
 * USB Interface that handles CAN information passed to it by any device adhearing to the SocketCAN protocall (Serial CAN.)
 * */
class usb_interface : public QObject
{
    Q_OBJECT
public slots:
    void handleReadyRead();

public:
    explicit usb_interface(QObject *parent = 0);
    ~usb_interface();

    bool openCAN();
    void closeCAN();

    static QString messages;

private:
    QString parseCANMessage(QString str);
    QSerialPort port;
};

#endif // USB_INTERFACE_H
