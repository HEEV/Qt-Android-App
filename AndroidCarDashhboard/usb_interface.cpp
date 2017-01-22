#include "usb_interface.h"

// Creates a new USB_Interface class and attempts to open the CANtact port.
usb_interface::usb_interface(QObject *parent, UIRaceDataSet* dataSet) : QObject(parent)
{
    dataStore = dataSet;
    slcandActive = false;

    //Set up CAN settings.
    currentSettings.backendName = "socketcan";
    currentSettings.deviceInterfaceName = "can0";
    currentSettings.useConfigurationEnabled = false;
}

usb_interface::~usb_interface()
{
}


void usb_interface::connectCANDevice()
{
    //First set up the slcand system so that QT can connect to it.
    if(!slcandActive)
    {
        //Try to allow CAN bus to talk on the bus by first activating slcand and disabling the SELinux port restrictions
        QProcess slcand;
        slcand.start("su", QStringList() << "");
        slcand.waitForStarted();

        slcand.write("slcand -s 6 -S 3000000 -o -c /dev/ttyACM0 can0");
        slcand.closeWriteChannel();

        slcand.waitForFinished();

        QProcess ifconfig;
        ifconfig.start("su", QStringList() << "-c" << "ifconfig" << "can0" << "up");
        ifconfig.waitForStarted();
        ifconfig.waitForFinished();

        QProcess selinux;
        selinux.start("su", QStringList() << "-c" << "setenforce 0");
        selinux.waitForStarted();
        selinux.waitForFinished();

        slcandActive = true;
    }

    //Now set up QT's CAN service.
    QString errorString;
    canDevice = QCanBus::instance()->createDevice(currentSettings.backendName, currentSettings.deviceInterfaceName, &errorString);

    if(!canDevice)
    {
        qDebug() << "Error creating a CAN device \n";
    }

    //Connect the callbacks for the CAN bus
    connect(m_canDevice, &QCanBusDevice::errorOccurred,
            this, &usb_interface::receiveError);
    connect(m_canDevice, &QCanBusDevice::framesReceived,
            this, &usb_interface::checkMessages);
    connect(m_canDevice, &QCanBusDevice::framesWritten,
            this, &usb_interface::framesWritten);

    if (!m_canDevice->connectDevice()) {
        qDebug() << "Error" << QString(canDevice->errorString());

        delete canDevice;
        canDevice = nullptr;
    }
}

void usb_interface::disconnectCANDevice()
{
    //Disconnect the can variable first.
    if (!canDevice)
        return;

    canDevice->disconnectDevice();
    delete canDevice;
    canDevice = nullptr;

    //Now shut down slcand
    if(slcandActive)
    {
        QProcess pkill;
        pkill.start("pkill", QStringList() << "slcand");
    }
}


void usb_interface::receiveError(QCanBusDevice::CanBusError error) const
{
    switch (error) {
    case QCanBusDevice::ReadError:
    case QCanBusDevice::WriteError:
    case QCanBusDevice::ConnectionError:
    case QCanBusDevice::ConfigurationError:
    case QCanBusDevice::UnknownError:
        qWarning() << m_canDevice->errorString();
    default:
        break;
    }
}

void usb_interface::checkMessages()
{
    if (!m_canDevice)
        return;

    while (m_canDevice->framesAvailable()) {
        const QCanBusFrame frame = m_canDevice->readFrame();

        QString view;
        if (frame.frameType() == QCanBusFrame::ErrorFrame)
            qDebug() << "Error: " << QString(canDevice->interpretErrorFrame(frame));
        else
            view = frame.toString();

    }
}

void usb_interface::framesWritten(qint64 count)
{
   qDebug() << "Frames written: " << count;
}

void usb_interface::dealWithMessage(QCanBusFrame frame)
{

}
