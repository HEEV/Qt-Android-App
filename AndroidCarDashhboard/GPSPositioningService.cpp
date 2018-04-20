#include "GPSPositioningService.h"

//This is in miliseconds and is how oftain the GPS is polled.
const int GPSPositioningService::gpsUpdateInterval = 500;
const qreal GPSPositioningService::lapStartLocationEnterRadius = 20.0;
const qreal GPSPositioningService::lapStartLocationExitRadius = 30.0;
const qreal GPSPositioningService::metersPerSecondToMilesPerHour = 2.237;

GPSPositioningService::GPSPositioningService(Logger *log, UIRaceDataset *data)
{
    tracking = false;
    logger = log;
    dataStore = data;
    lapStartLocationHasBeenSet = false;
    haveLeftStartRadius = false;

    //This will try to grab any GPS source it can, including IP address.
    source = QGeoPositionInfoSource::createDefaultSource(this);
    //Get the callback registered.
    connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)), this, SLOT(positionUpdated(QGeoPositionInfo)));
    //Set polling time.
    source->setUpdateInterval(gpsUpdateInterval);
}


bool GPSPositioningService::startTracking()
{
    if (!tracking)
    {
        lapStartLocationHasBeenSet = false;
        haveLeftStartRadius = false;
        //Start polling.
        source->startUpdates();
        tracking = true;
    }

    return true; // Does this return value have meaning? No.
}

void GPSPositioningService::stopTracking()
{
    if(tracking)
    {
        //Stop polling.
        source->stopUpdates();
        lapStartLocationHasBeenSet = false;
        haveLeftStartRadius = false;
        tracking = false;
    }
}

void GPSPositioningService::positionUpdated(const QGeoPositionInfo &info)
{
    QGeoCoordinate coord = info.coordinate();
    QString coords = QString::number(coord.latitude());
    coords += " : " + QString::number(coord.longitude());
    coords += " : " + QString::number(coord.altitude());
    qDebug() << coords;

    //This if is for setting the start location once we have the required accuracy on the GPS data.
    if (!lapStartLocationHasBeenSet && info.attribute(QGeoPositionInfo::HorizontalAccuracy) < 6.7)
    {
        lapStartLocation = info.coordinate();
        lapStartLocationHasBeenSet = true;
        logger->println(logPrefix + "Lap start location set: " + lapStartLocation.toString().toStdString());
        logger->println(logPrefix + "Accuracy: " + QString::number(info.attribute(QGeoPositionInfo::HorizontalAccuracy)).toStdString());
    }
    //logger->println(logPrefix + "Accuracy: " + QString::number(info.attribute(QGeoPositionInfo::HorizontalAccuracy)).toStdString());

    if (dataStore->getUseGPSSpeed() && info.hasAttribute(QGeoPositionInfo::GroundSpeed))
    {
        qreal mphGroundSpeed = info.attribute(QGeoPositionInfo::GroundSpeed) * metersPerSecondToMilesPerHour;

        dataStore->setGroundSpeed(mphGroundSpeed);
        dataStore->groundSpeedNotify();
    }

    dataStore->setGPSInfo(QGeoPositionInfo(info));

    if (haveLeftStartRadius && info.coordinate().distanceTo(lapStartLocation) < lapStartLocationEnterRadius)
    {
        haveLeftStartRadius = false;
        lapIncremented();
    }
    else if (info.coordinate().distanceTo(lapStartLocation) > lapStartLocationExitRadius)
    {
        haveLeftStartRadius = true;
    }
}
