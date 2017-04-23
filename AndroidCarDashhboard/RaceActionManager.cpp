#include "RaceActionManager.h"

RaceActionManager::RaceActionManager(CANInterface *can, DataProcessor *data, Logger *log, UIRaceDataset *ui, NetworkInterface *net)
{
    canInterface = can;
    dataProcessor = data;
    logger = log;
    uiInterface = ui;
    network = net;
    currentLapTime = QTime();
    totalRaceTime = QTime();
}

bool RaceActionManager::initConnections()
{
    //Canbus setup
    //How can we check whether we are already connected?
    bool canConnected = canInterface->startListening();
    uiInterface->setCanStatus(canConnected);
    uiInterface->canStatusNotify();

    //Network setup.
    // Assume that we don't need to check whether the network interface is
    // already connected before calling connectToServer()
    /*bool*/ networkConnected = network->connectToServer(this);
    uiInterface->setNetworkStatus(networkConnected);
    uiInterface->networkStatusNotify();

    return true; // This return value is meaningless, as of right now
}

bool RaceActionManager::startRace()
{
    initConnections();

    // Should this be put into a slot that occurs when network is connected?
    /*
    QJsonObject startUp;
    startUp.insert("SharedKey", "k5t452dewa432");
    startUp.insert("CarType", "Sting");
    startUp.insert("LapNum", "1");


    if(networkConnected)
    {
        network->sendJASON(startUp);
    }
    */

    //Set up pulse to check on things.
    raceTimer = new QTimer();
    connect(raceTimer, SIGNAL(timeout()), this, SLOT(updateCurrentTime()));
    raceTimer->start(timerPeriod);

    sendToServerTimer = new QTimer();
    connect(sendToServerTimer, SIGNAL(timeout()), this, SLOT(sendInfoToServer()));
    sendToServerTimer->start(sendToServerTimerPeriod);

    //Start keeping track of time.
    totalRaceTime.restart();
    totalRaceTime.start();
    currentLapTime.restart();
    currentLapTime.start();

    //Show on the UI that the race has started.
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
}

bool RaceActionManager::stopRace()
{
    // Need to re-evaluate this entire function once startRace() and initConnections() have been figured out
    /*
    if(raceStarted)
    {
        //Stop the update timer.
        raceTimer->stop();
        //Disconnects everything that is associated with the timer
        disconnect(raceTimer, 0, 0,0);
        totalRaceTime.restart();
        currentLapTime.restart();


        //Deal with network
        if(networkConnected)
        {
            network->disconnect();
            delete network;
        }

        //Notify the UI that the race has ended.
        uiInterface->setRaceStatus(false);
        uiInterface->raceStatusNotify();
        raceStarted = false;
        delete raceTimer;
    }
    logger->println((logPrefix + "Race stopped.").toStdString());
    */
    return true;
}

/**
 * @brief Builds a JSON message containing information such as gps location and groundspeed
 * and sends the message to the web server
 */
void RaceActionManager::sendInfoToServer()
{
    QGeoCoordinate currentCoordinate = uiInterface->getGPSInfo().coordinate();
    QJsonObject gpsMessage;
    gpsMessage.insert("latitude", QJsonValue(currentCoordinate.latitude()));
    gpsMessage.insert("longitude", QJsonValue(currentCoordinate.longitude()));
    // I'm guessing we don't actually need to know altitude
    //gpsMessage.insert("altitude", QJsonValue(currentCoordinate.altitude()));

    QJsonObject mainMessage;
    mainMessage.insert("time", totalRaceTime.elapsed());
    mainMessage.insert("groundspeed", uiInterface->getGroundSpeed());
    //mainMessageinsert("lapNumber", /*lap here*/);
    mainMessage.insert("coordinate", gpsMessage);

    network->sendJASON(mainMessage);
}

RaceActionManager::~RaceActionManager()
{
    if(raceTimer != nullptr)
    {
        delete raceTimer;
    }
}
