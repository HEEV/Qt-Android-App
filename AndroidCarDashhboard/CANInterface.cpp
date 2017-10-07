#include "CANInterface.h"

CANInterface::CANInterface(DataProcessor *dataProcessor, bool simulateInput)
{
    this->dataProcessor = dataProcessor;
    this->simulateInput = simulateInput;
    slcandActive = false;

    if(simulateInput)
    {
        QFile simuDataFile(":/simulationData.csv");

        if (!simuDataFile.open(QIODevice::ReadOnly | QIODevice::Text)) {

            qDebug() << simuDataFile.errorString();
            return;
        }

        QTextStream in(&simuDataFile);
        while (!in.atEnd()) {
            simuData temp;
            QString line = in.readLine();
            QStringList sLine = line.split(',');

            temp.typeID = sLine[0];
            temp.canID = sLine[1].toInt();
            temp.min = sLine[2].toInt();
            temp.max = sLine[3].toInt();
            temp.wForm = sLine[4];

            simulationDataVector.append(temp);
        }

        simulationTimer = new QTimer();
        connect(simulationTimer, SIGNAL(timeout()), this, SLOT(simulateInputFrames()));
    }
}

CANInterface::~CANInterface()
{
    stopListening();
    this->dataProcessor = nullptr;
    delete simulationTimer;
}

bool CANInterface::startListening()
{
    bool slcandSuccess = false;
    bool success = false;
    if(simulateInput)
    {
        simulationTimer->start(500);//Set the sampling reate to be half a second. In ms.
        success = true;
    }
    else
    {
        slcandSuccess = activateSlcand();
        //Start by making sure that we can use the slcan plugin that is provided by the QT library.
        if(QCanBus::instance()->plugins().contains(QStringLiteral("socketcan")) && device == nullptr)
        {
            device = QCanBus::instance()->createDevice(
                        QStringLiteral("socketcan"), QStringLiteral("can0"));

            //Connect the framesReceived signal interrupt to the readFrame method to deal with.
            connect(device, &QCanBusDevice::framesReceived, this, &CANInterface::readFrame);

            success = device->connectDevice();

        }
        // If we could not connect to the instance of slcand then go ahead and kill and say we failed.
        if(!success && slcandSuccess)
        {
            disableSlcand();
        }
    }
    return success;
}

void CANInterface::stopListening()
{
    if(simulateInput)
    {
        simulationTimer->stop();
    }
    else
    {
        device->disconnectDevice();
        disconnect(device, 0,0,0);
        disableSlcand();
        if(device != nullptr)
        {
            delete device;
        }
    }
}

bool CANInterface::writeCANFrame(int ID, QByteArray payload)
{
    QCanBusFrame frame;
    frame.setFrameId(ID);
    frame.setPayload(payload);
    return device->writeFrame(frame);
}

void CANInterface::simulateInputFrames()
{
    QVectorIterator<simuData> simIter(simulationDataVector);
    while(i.hasNext())
    {
        simuData currentData = simIter.next();
        QCanBusFrame simulatedFrame;
        simulatedFrame.setFrameId(currentData.canID);

        //Now we should simulate the byte data based on simulation type
        if(currentData.wForm == "sin")
        {

        }
        else if(currentData.wForm == "random")
        {
            qrand()
        }
    }
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
            dataProcessor->routeCANFrame(frame);
        }
    }
}

bool CANInterface::activateSlcand()
{
    QProcess ifconfigStop;
    //We have to pass the parameters as a list otherwise they get globbed together and fail to do anything.
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
