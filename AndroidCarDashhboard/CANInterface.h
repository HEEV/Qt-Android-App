#include <QCanBus>
#include <QTextCodec>
#include <QDebug>
#include <QCanBusFrame>
#include <QObject>
#include <QProcess>
#include "DataProcessor.h"

#ifdef Q_OS_WIN
#include "LinuxCANTypes.h"
#include <windows.h>
#endif


#ifndef CANINTERFACE_H
#define CANINTERFACE_H


class CANInterface : public QObject
{
    Q_OBJECT
public:
    explicit CANInterface(DataProcessor *dataProcessor, bool simulateInput);
    ~CANInterface();
    bool startListening(); //Start listening to the activity on the CAN bus.
    void stopListening();  //Stop listening to the CAN bus.
    bool writeCANFrame(int ID, QByteArray payload);

private Q_SLOTS:
    void readFrame();
    void simulateInputFrames();

private:
    bool slcandActive;
    bool simulateInput;
    QCanBusDevice *device;
    DataProcessor *dataProcessor;
    const string logPrefix = "CANInterface_SERVICE: ";
    bool activateSlcand();
    bool disableSlcand();

};

#endif // CANINTERFACE_H
