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

//Standard C++ library
#include <string>
#include <iostream>
#include <sstream>
#include <fcntl.h>
#include <errno.h>
#include <fcntl.h>
#include <termios.h>
#include <unistd.h>
#include <termio.h>

/*
 * USB Interface that handles CAN information passed to it by any device adhearing to the SocketCAN protocall (Serial CAN.)
 * */
class usb_interface
{
public:
    explicit usb_interface();
    ~usb_interface();

    //int openCloseLog(bool o_c);

    QString getMessages();

    void setMessages(QString string);
    void setMode(bool enableAndroid);
    void closecan();

    int printToNLog(QString info);

    static int fileDescriptor;
    static QString messages;
    static usb_interface *interfacePointer;
    static QFile *f;

signals:
    void messagesChanged();

public slots:
    void handleReadyRead();

private:
    QString parseCANMessage(QString str);



    bool isLogOpen = false;
    bool isSerialOpen = false;

    bool androidMode = false;
    QSerialPort port;
};

#endif // USB_INTERFACE_H
