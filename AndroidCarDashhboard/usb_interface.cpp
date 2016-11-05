#include "usb_interface.h"

// Creates a new USB_Interface class and attempts to open the CANtact port.
usb_interface::usb_interface(QObject *parent) : QObject(parent)
{
    openCAN();
}

usb_interface::~usb_interface()
{
    closeCAN();
}

// Looks for a CANtact port and attempts to open it if found.
// Returns true if successfuly, false otherwise.
bool usb_interface::openCAN()
{
    // Loop through all available serial ports
    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts())
    {
        // If this one is the CANtact, try to open it.
        if(info.description() == "CANtact dev")
        {
            port.setPort(info);

            bool openedSuccessfully = port.open(QIODevice::ReadWrite);
            if(openedSuccessfully)
            {
                connect(&port, &QSerialPort::readyRead, this, &usb_interface::handleReadyRead);
                QByteArray open = QString("O\r").toUtf8();
                port.write(open);

                return true;
            } else {
                return false;
            }
        }
    }

    // If we didn't find a CANtact, return false
    return false;
}

// Attempts to close the CANtact port if it is open.
void usb_interface::closeCAN()
{
    if (port.isOpen())
    {
        QByteArray close = QString("C\r").toUtf8();
        port.write(close);
        port.close();
    }
}

// Print a message when something arrives on the CANtact port
void usb_interface::handleReadyRead()
{
    qDebug() << "We got one! " << QString(port.readAll()) << endl;
}
