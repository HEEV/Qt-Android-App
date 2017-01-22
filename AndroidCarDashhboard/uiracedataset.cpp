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

void UIRaceDataSet::setGroundSpeed(int speed)
{
    groundSpeed = speed;
}

int UIRaceDataSet::getGroundSpeed()
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
