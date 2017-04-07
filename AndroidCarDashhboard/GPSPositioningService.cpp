#include "GPSPositioningService.h"

GPSPositioningService::GPSPositioningService(Logger *log)
{
    tracking = false;
    logger = log;
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
    }
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
    //logger->println((logTag + info).toStdString());
}
