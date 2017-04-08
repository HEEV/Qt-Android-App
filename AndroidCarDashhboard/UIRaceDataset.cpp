#include "UIRaceDataset.h"

UIRaceDataset::UIRaceDataset(QObject *parent) : QObject(parent)
{
    //Set defaults.
    projectedProgress = 0;
    groundSpeed = 0;
    speedSensorStatus = false;
    canStatus = false;
    totalTime = "00:00:00";
    currentLapTime = "00:00:00";
}

qreal UIRaceDataset::getProjectedProgress()
{
    return projectedProgress;
}

void UIRaceDataset::setProjectedProgress(double projectedProgress)
{
    this->projectedProgress = projectedProgress;
}

void UIRaceDataset::setGroundSpeed(qreal speed)
{
    groundSpeed = speed;
}

qreal UIRaceDataset::getGroundSpeed()
{
    return groundSpeed;
}

void UIRaceDataset::setSpeedSensorStatus(bool status)
{
    speedSensorStatus = status;
}

bool UIRaceDataset::getSpeedSensorStatus()
{
    return speedSensorStatus;
}

void UIRaceDataset::setCanStatus(bool status)
{
    canStatus = status;
}

bool UIRaceDataset::getCanStatus()
{
    return canStatus;
}

void UIRaceDataset::setTotalTime(QString time)
{
    totalTime = time;
}

QString UIRaceDataset::getTotalTime()
{
    return totalTime;
}

void UIRaceDataset::setCurrentLapTime(QString time)
{
    currentLapTime = time;
}

QString UIRaceDataset::getCurrentLapTime()
{
    return currentLapTime;
}

void UIRaceDataset::setRaceStatus(bool status)
{
    raceStatus = status;
}

bool UIRaceDataset::getRaceStatus()
{
    return raceStatus;
}

void UIRaceDataset::setGPSInfo(QGeoPositionInfo info)
{
    gpsInfo = info;
}

QGeoPositionInfo UIRaceDataset::getGPSInfo()
{
    return gpsInfo;
}
