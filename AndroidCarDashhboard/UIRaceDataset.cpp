#include "UIRaceDataset.h"

UIRaceDataset::UIRaceDataset(QObject *parent) : QObject(parent)
{
    //Set defaults.
    projectedProgress = 0;
    groundSpeed = 0;
    speedSensorStatus = false;
    canStatus = false;
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
