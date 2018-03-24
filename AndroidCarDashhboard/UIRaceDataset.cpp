#include "UIRaceDataset.h"

const int UIRaceDataset::FINAL_LAP_NUMBER = 10;

QString BatteryStates::CRITICAL = "BatteryCritical.png";
QString BatteryStates::URGENT   = "BatteryUrgent.png";
QString BatteryStates::CAUTION  = "BatteryCaution.png";
QString BatteryStates::GOOD     = "BatteryGood.png";

UIRaceDataset::UIRaceDataset(QObject *parent) : QObject(parent)
{
    //Set defaults.
    carName = "Urbie";
    projectedProgress = 0;
    groundSpeed = 0;
    averageSpeed = "0.0";
    speedSensorStatus = false;
    canStatus = false;
    totalTime = "00:00";
    currentLapTime = "00:00";
    lastLapTime = "00:00";
    currentLapNumber = 1;
    batteryState = BatteryStates::GOOD;
    isFinalLap = false;
    tempSliderVisible = 0;
    showMenu = true;
}

void UIRaceDataset::setTemperatureState(double temperature) {
    double critical = 30;
    double urgent = 20;
    double caution = 10;

    if (temperature < caution) {
        tempSliderVisible = 0;
        temperatureStateNotify();
    } else if (temperature < urgent) {
        tempSliderVisible = 1;
        temperatureStateNotify();
    } else if (temperature < critical) {
        tempSliderVisible = 2;
        temperatureStateNotify();
    } else {
        tempSliderVisible = 3;
        temperatureStateNotify();
    }
}

void UIRaceDataset::setBatteryState(double voltage) {
    double critical = 10;
    double urgent = 20;
    double caution = 30;

    if (voltage < critical) {
        batteryState = BatteryStates::CRITICAL;
        batteryStateNotify();
    } else if (voltage < urgent) {
        batteryState = BatteryStates::URGENT;
        batteryStateNotify();
    } else if (voltage < caution) {
        batteryState = BatteryStates::CAUTION;
        batteryStateNotify();
    } else {
        batteryState = BatteryStates::GOOD;
        batteryStateNotify();
    }
}

QString UIRaceDataset::getCarName()
{
    return carName;
}

void UIRaceDataset::setCarName(QString name)
{
    carName = name;
}

qreal UIRaceDataset::getProjectedProgress()
{
    return projectedProgress;
}

void UIRaceDataset::setProjectedProgress(double projectedProgress)
{
    this->projectedProgress = projectedProgress;
}

void UIRaceDataset::setUseGPSSpeed(bool useGPS){
    useGPSSpeed = useGPS;
}

bool UIRaceDataset::getUseGPSSpeed()
{
    return useGPSSpeed;
}

void UIRaceDataset::setGroundSpeed(qreal speed)
{
    groundSpeed = speed;
}

qreal UIRaceDataset::getGroundSpeed()
{
    return groundSpeed;
}

void UIRaceDataset::setAverageSpeed(QString average)
{
    averageSpeed = average;
}

QString UIRaceDataset::getAverageSpeed()
{
    return averageSpeed;
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

void UIRaceDataset::setNetworkStatus(bool status)
{
    networkStatus = status;
}

bool UIRaceDataset::getNetworkStatus()
{
    return networkStatus;
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

void UIRaceDataset::setLastLapTime(QString time)
{
    lastLapTime = time;
}

QString UIRaceDataset::getLastLapTime()
{
    return lastLapTime;
}

void UIRaceDataset::setCurrentLapNumber(int lapNumber)
{
    currentLapNumber = lapNumber;
    if (currentLapNumber == FINAL_LAP_NUMBER)
    {
        isFinalLap = true;
        isFinalLapNotify();
    }
    else
    {
        isFinalLap = false;
        isFinalLapNotify();
    }
}

int UIRaceDataset::getCurrentLapNumber()
{
    return currentLapNumber;
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

bool UIRaceDataset::getIsFinalLap()
{
    return isFinalLap;
}

void UIRaceDataset::setWindSpeed(qreal speed)
{
    windSpeed = speed;
}

qreal UIRaceDataset::getWindSpeed()
{
    return windSpeed;
}

QString UIRaceDataset::getBatteryState()
{
    return batteryState;
}

int UIRaceDataset::getTemperatureState()
{
    return tempSliderVisible;
}

void UIRaceDataset::setBatteryState(QString status)
{
    batteryState = status;
}

void UIRaceDataset::setMenuState(bool status)
{
    showMenu = status;
    menuStateNotify();
}

bool UIRaceDataset::getMenuState()
{
    return showMenu;
}

void UIRaceDataset::setMenuVisible() {
    setMenuState(true);
}

void UIRaceDataset::setMenuHidden() {
    setMenuState(false);
}

