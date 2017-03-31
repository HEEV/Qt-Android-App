#ifndef RACEACTIONMANAGER_H
#define RACEACTIONMANAGER_H

#include <QTimer>

#include "CANInterface.h"
#include "DataProcessor.h"
#include "Logger.h"
#include "UIRaceDataset.h"


class RaceActionManager
{
public:
    //We require pretty much all of the other classes in order to make this class work correctly.
    RaceActionManager(CANInterface &can, DataProcessor &data, Logger &log, UIRaceDataset &ui);


    bool startRace();
    bool stopRace();
    bool initConnections();


private:
    CANInterface *canInterface;
    DataProcessor *dataProcessor;
    Logger *logger;
    UIRaceDataset *uiInterface;

    QTimer *raceTimer;

};

#endif // RACEACTIONMANAGER_H
