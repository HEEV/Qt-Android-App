#include "uiracedataset.h"

UIRaceDataSet::UIRaceDataSet(QObject *parent) : QObject(parent)
{
    //Set defaults.
    projectedProgress = 0;
    groundSpeed = 0;
    speedSensorStatus = false;
    canStatus = false;
}

qreal UIRaceDataSet::getProjectedProgress()
{
    return projectedProgress;
}

void UIRaceDataSet::setProjectedProgress(double projectedProgress)
{
    this->projectedProgress = projectedProgress;
}

void UIRaceDataSet::setGroundSpeed(qreal speed)
{
    groundSpeed = speed;
}

qreal UIRaceDataSet::getGroundSpeed()
{
    return groundSpeed;
}

void UIRaceDataSet::setSpeedSensorStatus(bool status)
{
    speedSensorStatus = status;
}

bool UIRaceDataSet::getSpeedSensorStatus()
{
    return speedSensorStatus;
}

void UIRaceDataSet::setCanStatus(bool status)
{
    canStatus = status;
}

bool UIRaceDataSet::getCanStatus()
{
    return canStatus;
}
