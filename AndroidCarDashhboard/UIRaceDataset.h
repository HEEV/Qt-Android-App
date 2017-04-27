#ifndef UIRACEDATASET_H
#define UIRACEDATASET_H

#include <QObject>
#include <QGeoPositionInfo>
#include <Car.h>

class UIRaceDataset : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString carName READ getCarName WRITE setCarName NOTIFY carNameNotify)
    Q_PROPERTY(qreal projectedProgress READ getProjectedProgress NOTIFY projectedProgressNotify)
    Q_PROPERTY(qreal groundSpeed READ getGroundSpeed WRITE setGroundSpeed NOTIFY groundSpeedNotify)
    Q_PROPERTY(bool speedSensorStatus READ getSpeedSensorStatus NOTIFY speedSensorStatusNotify)
    Q_PROPERTY(bool canStatus READ getCanStatus WRITE setCanStatus NOTIFY canStatusNotify)
    Q_PROPERTY(bool networkStatus READ getNetworkStatus WRITE setNetworkStatus NOTIFY networkStatusNotify)
    Q_PROPERTY(QString totalTime READ getTotalTime WRITE setTotalTime NOTIFY totalTimeNotify)
    Q_PROPERTY(QString currentLapTime READ getCurrentLapTime WRITE setCurrentLapTime NOTIFY currentLapTimeNotify)
    Q_PROPERTY(QString lastLapTime READ getLastLapTime WRITE setLastLapTime NOTIFY lastLapTimeNotify)
    Q_PROPERTY(int currentLapNumber READ getCurrentLapNumber WRITE setCurrentLapNumber NOTIFY currentLapNumberNotify)
    Q_PROPERTY(bool raceStatus READ getRaceStatus WRITE setRaceStatus NOTIFY raceStatusNotify)
    Q_PROPERTY(QGeoPositionInfo gpsInfo READ getGPSInfo WRITE setGPSInfo NOTIFY gpsInfoNotify)

public:
    explicit UIRaceDataset(QObject *parent = 0);

    QString getCarName();
    void setCarName(QString name);

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

    void setLastLapTime(QString time);
    QString getLastLapTime();

    void setCurrentLapNumber(int lapNumber);
    int getCurrentLapNumber();

    void setRaceStatus(bool status);
    bool getRaceStatus();

    void setGPSInfo(QGeoPositionInfo info);
    QGeoPositionInfo getGPSInfo();

private:
    // Used by DataProcessor to choose whether to use Urbie's wheel circumference or
    // Sting's wheel circumference when calculating ground speed.
    // An enum would be a cleaner solution here, but I could not figure out how to expose an
    // enum to the qml GUI.
    QString carName;
    qreal projectedProgress;
    qreal groundSpeed;
    bool speedSensorStatus;
    bool canStatus;
    bool networkStatus;
    bool raceStatus;
    QString totalTime;
    QString currentLapTime;
    QString lastLapTime;
    int currentLapNumber;
    QGeoPositionInfo gpsInfo;

signals:
    void carNameNotify();
    void projectedProgressNotify();
    void groundSpeedNotify();
    void speedSensorStatusNotify();
    void canStatusNotify();
    void networkStatusNotify();
    void totalTimeNotify();
    void currentLapTimeNotify();
    void lastLapTimeNotify();
    void currentLapNumberNotify();
    void raceStatusNotify();
    void gpsInfoNotify();
public slots:
};

#endif // UIRACEDATASET_H
