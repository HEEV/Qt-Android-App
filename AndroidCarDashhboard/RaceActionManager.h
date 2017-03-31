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
    RaceActionManager(CANInterface &can, DataProcessor &data, Logger &log, UIRaceDataset &ui);

    bool initConnections();
    Q_INVOKABLE bool startRace();
    Q_INVOKABLE bool stopRace();


private slots:
    void updateCurrentTime();

private:
    const QString logPrefix = "RACE_MANAGER: ";

    unsigned long totalTimeMili = 0;
    unsigned int lapTimeMili = 0;
    const int timerPeriod = 10; //In miliseconds.

    CANInterface *canInterface;
    DataProcessor *dataProcessor;
    Logger *logger;
    UIRaceDataset *uiInterface;

    QTimer *raceTimer;

};

#endif // RACEACTIONMANAGER_H
