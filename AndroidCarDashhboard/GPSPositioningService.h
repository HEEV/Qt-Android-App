#ifndef GPSPOSITIONINGSERVICE_H
#define GPSPOSITIONINGSERVICE_H

#include <QObject>
#include <QGeoCoordinate>
#include <QGeoPositionInfoSource>

#include "Logger.h"

class GPSPositioningService: public QObject
{
    Q_OBJECT
public:
    GPSPositioningService(Logger *log);

    bool startTracking();
    void stopTracking();

private slots:
    void positionUpdated(const QGeoPositionInfo &info);

private:
    QGeoPositionInfoSource *source;
    Logger *logger;
    const QString logTag = "GPS_SERVICE: ";
    const int gpsUpdateInterval = 500;
    bool tracking;
};

#endif // GPSPOSITIONINGSERVICE_H
