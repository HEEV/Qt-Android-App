#ifndef RACEACTIONMANAGER_H
#define RACEACTIONMANAGER_H

#include <QObject>
#include <QTimer>
#include <QTime>

//Removes annoying circular dependancy issue.
class RaceActionManager;

//Local includes
#include "CANInterface.h"
#include "DataProcessor.h"
#include "Logger.h"
#include "UIRaceDataset.h"
#include "NetworkInterface.h"


class RaceActionManager: public QObject
{
    Q_OBJECT


public:
    //We require pretty much all of the other classes in order to make this class work correctly.
    RaceActionManager(CANInterface *can, DataProcessor *data, Logger *log, UIRaceDataset *ui, NetworkInterface *net);
    ~RaceActionManager();

    bool initConnections();
    Q_INVOKABLE bool startRace();
    Q_INVOKABLE bool stopRace();

private slots:
    void updateCurrentTime();
    void sendInfoToServer();

private:
    const QString logPrefix = "RACE_MANAGER: ";

    static const int timerPeriod = 500; //In miliseconds.
    static const int sendToServerTimerPeriod = 1000;

    bool raceStarted;
    bool networkConnected;
    bool gpsStarted;

    CANInterface *canInterface;
    DataProcessor *dataProcessor;
    Logger *logger;
    UIRaceDataset *uiInterface;
    NetworkInterface *network;

    QTimer *raceTimer;
    QTimer *sendToServerTimer;
    QTime totalRaceTime;
    QTime currentLapTime;

};

#endif // RACEACTIONMANAGER_H
