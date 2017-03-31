#include "RaceActionManager.h"

RaceActionManager::RaceActionManager(CANInterface &can, DataProcessor &data, Logger &log, UIRaceDataset &ui)
{
    canInterface = can;
    dataProcessor = data;
    logger = log;
    uiInterface = ui;
}

bool RaceActionManager::initConnections()
{

    return true;
}

bool RaceActionManager::startRace()
{
    raceTimer = new QTimer();
    connect(raceTimer, SINGAL(timeout()), this, SLOT(updateCurrentTime()));
    raceTimer->start(100);
    logger->println(logPrefix + "Race started.");
    return true;
}

void RaceActionManager::updateCurrentTime()
{
    QTime time = totalTimeMili + timerPeriod;
    QString text = time.toString("mm:ss:zz");
    uiInterface->setCurrentLapTime(text);
    uiInterface->setTotalTime(text);
}


bool RaceActionManager::stopRace()
{
    if(raceStarted)
    {
        raceTimer->stop();
        //Disconnects everything that is associated with the timer
        disconnect(raceTime, 0, 0,0);
        delete raceTimer;
    }
    logger->println(logPrefix + "Race stopped.");
    return true;
}

RaceActionManager::~RaceActionManager()
{
    if(raceTimer != nullptr)
    {
        delete raceTimer;
    }
}
