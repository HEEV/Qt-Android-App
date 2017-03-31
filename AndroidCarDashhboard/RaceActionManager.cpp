#include "RaceActionManager.h"

RaceActionManager::RaceActionManager(CANInterface *can, DataProcessor *data, Logger *log, UIRaceDataset *ui)
{
    canInterface = can;
    dataProcessor = data;
    logger = log;
    uiInterface = ui;
    currentLapTime = QTime(0,0,0,0);
    totalRaceTime = QTime();
}

bool RaceActionManager::initConnections()
{

    return true;
}

bool RaceActionManager::startRace()
{
    raceTimer = new QTimer();
    connect(raceTimer, SIGNAL(timeout()), this, SLOT(updateCurrentTime()));
    raceTimer->start(100);
    totalRaceTime.start();
    currentLapTime.start();
    uiInterface->setRaceStatus(true);
    uiInterface->raceStatusNotify();
    logger->println((logPrefix + "Race started.").toStdString());
    raceStarted = true;
    return true;
}

void RaceActionManager::updateCurrentTime()
{
    QString totalText = totalRaceTime.toString("mm:ss:zz");
    QString currentLapText = currentLapTime.toString("mm:ss:zz");
    uiInterface->setCurrentLapTime(totalText);
    uiInterface->currentLapTimeNotify();
    uiInterface->setTotalTime(currentLapText);
    uiInterface->totalTimeNotify();
    logger->println(QString("Passing: " + totalText).toStdString());
}


bool RaceActionManager::stopRace()
{
    if(raceStarted)
    {
        raceTimer->stop();
        //Disconnects everything that is associated with the timer
        disconnect(raceTimer, 0, 0,0);
        totalRaceTime.restart();
        currentLapTime.restart();
        uiInterface->setRaceStatus(false);
        uiInterface->raceStatusNotify();
        raceStarted = false;
        delete raceTimer;
    }
    logger->println((logPrefix + "Race stopped.").toStdString());
    return true;
}

RaceActionManager::~RaceActionManager()
{
    if(raceTimer != nullptr)
    {
        delete raceTimer;
    }
}
