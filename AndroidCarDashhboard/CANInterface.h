#include <QTextCodec>
#include <QDebug>
#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QDateTime>
#include <QVector>
#include <QString>
#include <QUrl>
#include <QLatin1String>
#include <QTextStream>
#include <QDebug>
#include <QStringList>
#include <functional>
#include "DataProcessor.h"
#include "canBus.h"

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
    void readFrame(can_frame frame);
    void simulateInputFrames();

private:
    CanBusModule canBus;
    bool slcandActive;
    bool simulateInput;
    QTimer *simulationTimer;
    DataProcessor *dataProcessor;
    const string logPrefix = "CANInterface_SERVICE: ";
    bool activateSlcand();
    bool disableSlcand();

    typedef struct {        // Struct to store simulation data from csv file
        QString typeID;
        int canID;
        int min;
        int max;
        QString wForm;
    } simuData;

    QVector<simuData> simulationDataVector;
};

#endif // CANINTERFACE_H
