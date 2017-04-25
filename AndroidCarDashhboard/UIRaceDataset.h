#ifndef UIRACEDATASET_H
#define UIRACEDATASET_H

#include <QObject>
#include <QGeoPositionInfo>

class UIRaceDataset : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal projectedProgress READ getProjectedProgress NOTIFY projectedProgressNotify)
    Q_PROPERTY(qreal groundSpeed READ getGroundSpeed WRITE setGroundSpeed NOTIFY groundSpeedNotify)
    Q_PROPERTY(bool speedSensorStatus READ getSpeedSensorStatus NOTIFY speedSensorStatusNotify)
    Q_PROPERTY(bool canStatus READ getCanStatus WRITE setCanStatus NOTIFY canStatusNotify)
    Q_PROPERTY(bool networkStatus READ getNetworkStatus WRITE setNetworkStatus NOTIFY networkStatusNotify)
    Q_PROPERTY(QString totalTime READ getTotalTime WRITE setTotalTime NOTIFY totalTimeNotify)
    Q_PROPERTY(QString currentLapTime READ getCurrentLapTime WRITE setCurrentLapTime NOTIFY currentLapTimeNotify)
    Q_PROPERTY(bool raceStatus READ getRaceStatus WRITE setRaceStatus NOTIFY raceStatusNotify)
    Q_PROPERTY(QGeoPositionInfo gpsInfo READ getGPSInfo WRITE setGPSInfo NOTIFY gpsInfoNotify)

public:
    explicit UIRaceDataset(QObject *parent = 0);

    void setProjectedProgress(double projectedProgress);
    qreal getProjectedProgress();

    void setGroundSpeed(qreal speed);
    qreal getGroundSpeed();

    void setSpeedSensorStatus(bool status);
    bool getSpeedSensorStatus();

    void setCanStatus(bool status);
    bool getCanStatus();

    void setNetworkStatus(bool status);
    bool getNetworkStatus();

    void setTotalTime(QString time);
    QString getTotalTime();

    void setCurrentLapTime(QString time);
    QString getCurrentLapTime();

    void setRaceStatus(bool status);
    bool getRaceStatus();

    void setGPSInfo(QGeoPositionInfo info);
    QGeoPositionInfo getGPSInfo();

private:
    qreal projectedProgress;
    qreal groundSpeed;
    bool speedSensorStatus;
    bool canStatus;
    bool networkStatus;
    bool raceStatus;
    QString totalTime;
    QString currentLapTime;
    QGeoPositionInfo gpsInfo;

signals:
    void projectedProgressNotify();
    void groundSpeedNotify();
    void speedSensorStatusNotify();
    void canStatusNotify();
    void networkStatusNotify();
    void totalTimeNotify();
    void currentLapTimeNotify();
    void raceStatusNotify();
    void gpsInfoNotify();
public slots:
};

#endif // UIRACEDATASET_H
