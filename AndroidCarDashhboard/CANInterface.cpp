#include "CANInterface.h"

CANInterface::CANInterface(DataProcessor *dataProcessor)
{
    this->dataProcessor = dataProcessor;
}

bool CANInterface::startListening()
{
    bool success = false;
    //Start by making sure that we can use the slcan plugin that is provided by the QT library.
    if(QCanBus::instance()->plugins().contains(QStringLiteral("socketcan")))
    {
        device = QCanBus::instance()->createDevice(
                    QStringLiteral("socketcan"), QStringLiteral("can0"));

        connect(device, &QCanBusDevice::framesReceived, this, &CANInterface::readFrame); //Connect the framesReceived signal interrupt to the readFrame method to deal with.

        success = device->connectDevice();

    }
    return success;
}

void CANInterface::stopListening()
{
    device->disconnectDevice();
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
    while (device->framesAvailable()) {
        const QCanBusFrame frame = device->readFrame();

        if (frame.frameType() == QCanBusFrame::ErrorFrame)
            return;
        else
            dataProcessor->routeCANFrame(frame);
    }
}
