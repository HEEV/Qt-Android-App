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

    raceStarted = false;
    uiInterface->setRaceStatus(raceStarted);
    uiInterface->raceStatusNotify();

    raceTimer = new QTimer();
    connect(raceTimer, SIGNAL(timeout()), this, SLOT(updateCurrentTime()));
    sendToServerTimer = new QTimer();
    connect(sendToServerTimer, SIGNAL(timeout()), this, SLOT(sendInfoToServer()));
    indicatorUpdaterTimer = new QTimer();
    connect(indicatorUpdaterTimer, SIGNAL(timeout()), this, SLOT(updateIndicatorLights()));
}

bool RaceActionManager::initConnections()
{
    //Canbus setup
    if (!canConnected)
    {
        canConnected = canInterface->startListening();
    }
    uiInterface->setCanStatus(canConnected);
    uiInterface->canStatusNotify();

    //Network setup.
    // connecToServer() does no harm if called when network is already connected
    // in fact, this call is necessary because it tells the network interface
    // that it should attempt to reconnect if it loses its connection.
    network->connectToServer(this);
    uiInterface->setNetworkStatus(network->isConnected());
    uiInterface->networkStatusNotify();

    return true; // This return value is meaningless, as of right now
}

bool RaceActionManager::startRace()
{
    initConnections();

    //TODO: set approprate car here
    dataProcessor->setWheelCircumference(uiInterface->getCarName());

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
    indicatorUpdaterTimer->start(updateIndicatorPeriod);
    raceTimer->start(timerPeriod);
    sendToServerTimer->start(sendToServerTimerPeriod);

    //Start keeping track of time.
    totalRaceTime.start();
    currentLapTime.start();
    updateCurrentTime();

    //Show on the UI that the race has started.
    raceStarted = true;
    uiInterface->setRaceStatus(raceStarted);
    uiInterface->raceStatusNotify();

    logger->println((logPrefix + "Race started.").toStdString());

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

// Checks the status of the can and network interfaces then sets the UI
// indicator lights accordingly
void RaceActionManager::updateIndicatorLights()
{
    uiInterface->setNetworkStatus(network->isConnected());
    uiInterface->networkStatusNotify();

    uiInterface->setCanStatus(canConnected);
    uiInterface->canStatusNotify();

}

bool RaceActionManager::stopRace()
{
    // Need to re-evaluate this entire function once startRace() and initConnections() have been figured out

    if(raceStarted)
    {
        //Stop the update timer.
        raceTimer->stop();
        sendToServerTimer->stop();
        indicatorUpdaterTimer->stop();

        if (canConnected)
        {
            canInterface->stopListening();
            canConnected = false;
        }

        //Deal with network
        // disconnect() does no harm if called when the network interface is
        // already disconnected. In fact, this call is necessary because it
        // tells the network interface to not attempt to reconnect should it
        // encounter a connection error.
        network->disconnect();

        //Notify the UI that the race has ended.
        updateIndicatorLights();
        uiInterface->setRaceStatus(false);
        uiInterface->raceStatusNotify();

        raceStarted = false;
    }
    logger->println((logPrefix + "Race stopped.").toStdString());

    return true;
}

/**
 * @brief Builds a JSON message containing information such as gps location and groundspeed
 * and sends the message to the web server
 */
void RaceActionManager::sendInfoToServer()
{
    if (network->isConnected())
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
}

RaceActionManager::~RaceActionManager()
{
    if(raceTimer != nullptr)
    {
        delete raceTimer;
    }
}
