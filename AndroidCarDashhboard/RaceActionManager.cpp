#include "RaceActionManager.h"

RaceActionManager::RaceActionManager(CANInterface *can, DataProcessor *data, Logger *log, UIRaceDataset *ui)
{
    canInterface = can;
    dataProcessor = data;
    logger = log;
    uiInterface = ui;
    currentLapTime = QTime();
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
    totalRaceTime.restart();
    totalRaceTime.start();
    currentLapTime.restart();
    currentLapTime.start();
    uiInterface->setRaceStatus(true);
    uiInterface->raceStatusNotify();
    logger->println((logPrefix + "Race started.").toStdString());
    raceStarted = true;
    return true;
}

void RaceActionManager::updateCurrentTime()
{
    int totalTimeMS = totalRaceTime.elapsed();
    int currentLapTimeMS = currentLapTime.elapsed();
    QString totalText = QString("%1:%2:%3").arg( totalTimeMS / 60000        , 2, 10, QChar('0'))
                                           .arg((totalTimeMS % 60000) / 1000, 2, 10, QChar('0'))
                                           .arg((totalTimeMS % 1000)        , 3, 10, QChar('0'));
    QString currentLapText = QString("%1:%2:%3").arg( currentLapTimeMS / 60000        , 2, 10, QChar('0'))
                                                .arg((currentLapTimeMS % 60000) / 1000, 2, 10, QChar('0'))
                                                .arg((currentLapTimeMS % 1000)        , 3, 10, QChar('0'));
    uiInterface->setCurrentLapTime(totalText);
    uiInterface->currentLapTimeNotify();
    uiInterface->setTotalTime(currentLapText);
    uiInterface->totalTimeNotify();
    //logger->println(QString("Passing: " + QString::number(totalTimeMS)).toStdString());
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
