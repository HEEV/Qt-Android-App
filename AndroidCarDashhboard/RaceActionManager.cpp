#include "RaceActionManager.h"

RaceActionManager::RaceActionManager(CANInterface *can, DataProcessor *data, Logger *log, UIRaceDataset *ui, GPSPositioningService *gps, NetworkInterface *net)
{
    canInterface = can;
    dataProcessor = data;
    logger = log;
    uiInterface = ui;
    network = net;
    gpsService = gps;
    currentLapTime = QTime();
    totalRaceTime = QTime();
}

bool RaceActionManager::initConnections()
{

    return true;
}

bool RaceActionManager::startRace()
{
    logger->println("Connecting to server.");

    //Network setup.
    networkConnected = network->connectToServer(this);

    QJsonObject startUp;
    startUp.insert("SharedKey", "k5t452dewa432");
    startUp.insert("CarType", "Sting");
    startUp.insert("LapNum", "1");

    if(networkConnected)
    {
        // Don't need to log this because NetworkInterface logs its connection activity
        //logger->println("Connected.");
        network->sendJASON(startUp);
    }
    else
    {
        // Don't need to log this because NetworkInterface logs its connection activity
        //logger->println("Unable to connect.");
    }

    //Start the GPS service.
    gpsStarted = gpsService->startTracking();

    //Set up pulse to check on things.
    raceTimer = new QTimer();
    connect(raceTimer, SIGNAL(timeout()), this, SLOT(updateCurrentTime()));
    raceTimer->start(timerPeriod);

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


    //Simple network send.
    QJsonObject test;
    test.insert("Time", totalText);
    bool sent = network->sendJASON(test);
    //logger->println(QString("Passing: " + QString::number(totalTimeMS)).toStdString());
}


bool RaceActionManager::stopRace()
{
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
    return true;
}


void RaceActionManager::updateNetwork(QJsonObject json)
{
    QString response = json["response"].toString();
    logger->println(response.toStdString());
}

RaceActionManager::~RaceActionManager()
{
    if(raceTimer != nullptr)
    {
        delete raceTimer;
    }
}
