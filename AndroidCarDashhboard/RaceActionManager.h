#ifndef RACEACTIONMANAGER_H
#define RACEACTIONMANAGER_H

#include <QObject>
#include <QTimer>
#include <QTime>

#include "CANInterface.h"
#include "DataProcessor.h"
#include "Logger.h"
#include "UIRaceDataset.h"


class RaceActionManager: public QObject
{
    Q_OBJECT


public:
    //We require pretty much all of the other classes in order to make this class work correctly.
    RaceActionManager(CANInterface *can, DataProcessor *data, Logger *log, UIRaceDataset *ui);
    ~RaceActionManager();

    bool initConnections();
    Q_INVOKABLE bool startRace();
    Q_INVOKABLE bool stopRace();


private slots:
    void updateCurrentTime();

private:
    const QString logPrefix = "RACE_MANAGER: ";

    static const int timerPeriod = 10; //In miliseconds.

    bool raceStarted;

    CANInterface *canInterface;
    DataProcessor *dataProcessor;
    Logger *logger;
    UIRaceDataset *uiInterface;

    QTimer *raceTimer;
    QTimer *updateGPS;
    QTime totalRaceTime;
    QTime currentLapTime;

};

#endif // RACEACTIONMANAGER_H
