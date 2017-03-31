#include "RaceActionManager.h"

RaceActionManager::RaceActionManager(CANInterface &can, DataProcessor &data, Logger &log, UIRaceDataset &ui)
{
    canInterface = can;
    dataProcessor = data;
    logger = log;
    uiInterface = ui;
}


bool RaceActionManager::startRace()
{
    raceTimer = new QTimer();
    return true;
}


RaceActionManager::~RaceActionManager()
{

}
