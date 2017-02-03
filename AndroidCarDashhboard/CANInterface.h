#include <QCanBus>
#include <QCanBusFrame>
#include "DataProcessor.h"


#ifndef CANINTERFACE_H
#define CANINTERFACE_H


class CANInterface
{
public:
    CANInterface(DataProcessor *dataProcessor);
    bool startListening();
    void stopListening();
    bool writeCANFrame(int ID, QByteArray payload);

private:
    void readFrame();

    QCanBusDevice *device;
    DataProcessor *dataProcessor;
};

#endif // CANINTERFACE_H
