#ifndef GPSPOSITIONINGSERVICE_H
#define GPSPOSITIONINGSERVICE_H

#include <QObject>
#include <QGeoCoordinate>
#include <QGeoPositionInfoSource>

#include "Logger.h"
#include "UIRaceDataset.h"

class GPSPositioningService: public QObject
{
    Q_OBJECT
public:
    GPSPositioningService(Logger *log, UIRaceDataset *data);

    bool startTracking();
    void stopTracking();

private slots:
    void positionUpdated(const QGeoPositionInfo &info);

private:
    QGeoPositionInfoSource *source;
    Logger *logger;
    UIRaceDataset *dataStore;
    const QString logTag = "GPS_SERVICE: ";
    static const int gpsUpdateInterval;
    bool tracking;
};

#endif // GPSPOSITIONINGSERVICE_H
