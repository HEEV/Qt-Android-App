#include "CANInterface.h"

CANInterface::CANInterface(DataProcessor *dataProcessor)
{
    this->dataProcessor = dataProcessor;
    slcandActive = false;
    //startListening(); //TEMP for TEST
}

CANInterface::~CANInterface()
{
    stopListening(); //TEMP for TEST.
    this->dataProcessor = nullptr;
}

bool CANInterface::startListening()
{
    bool slcandSuccess = activateSlcand();
    bool success = false;
    //Start by making sure that we can use the slcan plugin that is provided by the QT library.
    if(QCanBus::instance()->plugins().contains(QStringLiteral("socketcan")))
    {
        device = QCanBus::instance()->createDevice(
                    QStringLiteral("socketcan"), QStringLiteral("can0"));

        connect(device, &QCanBusDevice::framesReceived, this, &CANInterface::readFrame); //Connect the framesReceived signal interrupt to the readFrame method to deal with.

        success = device->connectDevice();

    }
    if(!success && slcandSuccess) // If we could not connect to the instance of slcand then go ahead and kill and say we failed.
    {
        disableSlcand();
    }
    return success;
}

void CANInterface::stopListening()
{
    device->disconnectDevice();
    disableSlcand();
}

bool CANInterface::writeCANFrame(int ID, QByteArray payload)
{
    QCanBusFrame frame;
    frame.setFrameId(ID);
    frame.setPayload(payload);
    return device->writeFrame(frame);
}

void CANInterface::readFrame()
{
    while (device->framesAvailable())
    {
        const QCanBusFrame frame = device->readFrame();

        if (frame.frameType() == QCanBusFrame::ErrorFrame)
        {
            qDebug() << "Error frame\n";
            return;
        }
        else
        {
            qDebug() << "Recieved frame. ID: " << QString::number(frame.frameId()) << "Content: " << (QString)QTextCodec::codecForMib(1015)->toUnicode(frame.payload()) << "\n"; //TEMP for TEST
            dataProcessor->routeCANFrame(frame);

        }
    }
}

bool CANInterface::activateSlcand()
{
    QProcess ifconfigStop;
    ifconfigStop.start("su", QStringList() << "-c" << "ifconfig" << "can0" << "down");
    ifconfigStop.waitForStarted();
    ifconfigStop.waitForFinished();

    QProcess pkill;
    pkill.start("su", QStringList() << "-c" << "pkill" << "slcand");
    pkill.waitForFinished();
    slcandActive = false;
    if(!slcandActive)
    {
        //Try to allow CAN bus to talk on the bus by first activating slcand and disabling the SELinux port restrictions
        QProcess slcand;
        slcand.start("su", QStringList() << "");
        slcand.waitForStarted();

        slcand.write("slcand -s 6 -S 3000000 -o -c /dev/ttyACM* can0");
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
    return slcandActive;
}

bool CANInterface::disableSlcand()
{
    bool success = false;
    if(slcandActive)
    {
        QProcess pkill;
        pkill.start("su", QStringList() << "-c" << "pkill" << "slcand");
        pkill.waitForFinished();
        slcandActive = false;
        success = true;
    }
    return success;
}
