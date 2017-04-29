#include "GPSPositioningService.h"

const int GPSPositioningService::gpsUpdateInterval = 500;
const qreal GPSPositioningService::lapStartLocationEnterRadius = 15.0;
const qreal GPSPositioningService::lapStartLocationExitRadius = 20.0;
const qreal GPSPositioningService::metersPerSecondToMilesPerHour = 2.237;

GPSPositioningService::GPSPositioningService(Logger *log, UIRaceDataset *data)
{
    tracking = false;
    logger = log;
    dataStore = data;
    lapStartLocationHasBeenSet = false;
    haveLeftStartRadius = false;

    source = QGeoPositionInfoSource::createDefaultSource(this);
    connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)), this, SLOT(positionUpdated(QGeoPositionInfo)));
    source->setUpdateInterval(gpsUpdateInterval);
}


bool GPSPositioningService::startTracking()
{
    if (!tracking)
    {
        lapStartLocationHasBeenSet = false;
        haveLeftStartRadius = false;
        source->startUpdates();
        tracking = true;
    }

    return true; // Does this return value have meaning?
}

void GPSPositioningService::stopTracking()
{
    if(tracking)
    {
        source->stopUpdates();
        lapStartLocationHasBeenSet = false;
        haveLeftStartRadius = false;
        tracking = false;
    }
}

void GPSPositioningService::positionUpdated(const QGeoPositionInfo &info)
{
    //QGeoCoordinate coord = info.coordinate();
    //QString coords = QString::number(coord.latitude());
    //coords += " : " + QString::number(coord.longitude());
    //coords += " : " + QString::number(coord.altitude());
    //logger->println((logTag + coords).toStdString());
    if (!lapStartLocationHasBeenSet)
    {
        lapStartLocation = info.coordinate();
        lapStartLocationHasBeenSet = true;
        logger->println(logPrefix + "Lap start location set: " + lapStartLocation.toString().toStdString());
    }

    if (dataStore->getUseGPSSpeed())
    {
        dataStore->setGroundSpeed(info.attribute(QGeoPositionInfo::GroundSpeed) * metersPerSecondToMilesPerHour);
        dataStore->groundSpeedNotify();
    }

    dataStore->setGPSInfo(QGeoPositionInfo(info));

    if (haveLeftStartRadius && info.coordinate().distanceTo(lapStartLocation) < lapStartLocationEnterRadius)
    {
        haveLeftStartRadius = false;
        lapIncremented();
    } else if (info.coordinate().distanceTo(lapStartLocation) > lapStartLocationExitRadius)
    {
        haveLeftStartRadius = true;
    }
}
