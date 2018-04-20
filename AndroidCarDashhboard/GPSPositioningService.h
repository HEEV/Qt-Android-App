#ifndef GPSPOSITIONINGSERVICE_H
#define GPSPOSITIONINGSERVICE_H

#include <QObject>
#include <QGeoCoordinate>
#include <QDebug>
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

signals:
    void lapIncremented();

private slots:
    void positionUpdated(const QGeoPositionInfo &info);

private:
    QGeoPositionInfoSource *source;
    QGeoCoordinate lapStartLocation;
    bool lapStartLocationHasBeenSet;
    static const qreal lapStartLocationEnterRadius;
    static const qreal lapStartLocationExitRadius;
    bool haveLeftStartRadius;

    Logger *logger;
    UIRaceDataset *dataStore;
    const string logPrefix = "GPS_SERVICE: ";
    static const int gpsUpdateInterval;
    static const qreal metersPerSecondToMilesPerHour;
    bool tracking;
};

#endif // GPSPOSITIONINGSERVICE_H
