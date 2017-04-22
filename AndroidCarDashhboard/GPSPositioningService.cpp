#include "GPSPositioningService.h"

const int GPSPositioningService::gpsUpdateInterval = 500;

GPSPositioningService::GPSPositioningService(Logger *log, UIRaceDataset *data)
{
    tracking = false;
    logger = log;
    dataStore = data;
}


bool GPSPositioningService::startTracking()
{
    source = QGeoPositionInfoSource::createDefaultSource(this);
    if(source)
    {
        connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)), this, SLOT(positionUpdated(QGeoPositionInfo)));
        source->setUpdateInterval(gpsUpdateInterval);
        source->startUpdates();
        tracking = true;
        return true;
    }
    return false;
}

void GPSPositioningService::stopTracking()
{
    if(tracking)
    {
        source->stopUpdates();
        disconnect(source, 0,0,0);
        delete source;
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
    dataStore->setGPSInfo(QGeoPositionInfo(info));
}
