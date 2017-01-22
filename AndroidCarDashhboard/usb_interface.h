#ifndef USB_INTERFACE_H
#define USB_INTERFACE_H

//QT libs.
#include <QCanBusDevice>
#include <QCanBus>
#include <QCanBusFrame>
#include <QCloseEvent>
#include <QtDebug>
#include <QTimer>
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

//Local includes
#include "uiracedataset.h"

/*
 * USB Interface that handles CAN information passed to it by any device adhearing to the SocketCAN protocall (Serial CAN.)
 * */
class usb_interface : public QObject
{
    Q_OBJECT
public:
    explicit usb_interface(QObject *parent = 0, UIRaceDataSet* dataSet);
    ~usb_interface();

    void connectCANDevice();
    void disconnectCANDevice();



    //CAN set up vars.
    typedef QPair<QCanBusDevice::ConfigurationKey, QVariant> ConfigurationItem;

    struct Settings {
        QString backendName;
        QString deviceInterfaceName;
        QList<ConfigurationItem> configurations;
        bool useConfigurationEnabled;
    };

private Q_SLOTS:
    //CAN Handler functions
    void receiveError(QCanBusDevice::CanBusError) const;
    void checkMessages();
    void framesWritten();

private:

    void dealWithMessage(QCanBusFrame frame);

    UIRaceDataSet* dataStore;
    QCanBusDevice *canDevice;

    Settings currentSettings;
    bool slcandActive;
};

#endif // USB_INTERFACE_H
