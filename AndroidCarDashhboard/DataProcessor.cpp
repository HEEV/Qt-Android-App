#include "DataProcessor.h"

//1154 for time between pulses.
//1150 for pulses per second.

const int DataProcessor::TACHOMETER_ID = 1150;
const int DataProcessor::PITOT_ID = 1648;
const int DataProcessor::EFI_PRESSURE_ID = 1;
const int DataProcessor::MEGASQUIRT_ID = 2;
const int DataProcessor::CURRENT_ID = 3;
const int DataProcessor::VOLTAGE_ID = 4;

DataProcessor::DataProcessor(UIRaceDataset *uiRaceDataset)
{
    this->raceDataset = uiRaceDataset;
}

void DataProcessor::routeCANFrame(QCanBusFrame frame)
{
    int id = frame.frameId();
    QByteArray data = frame.payload();
    //qDebug() << "Frame ID: " << QString::number(id) << "\n";

    // For efficienty, these cases should be ordered with the most
    // frequent ids at the top.
    switch(id)
    {
    case DataProcessor::TACHOMETER_ID:
        updateGroundSpeed(data);
        break;
    case DataProcessor::PITOT_ID:
        updateAirSpeed(data);
        break;
    case DataProcessor::EFI_PRESSURE_ID:
        updateEFIPressure(data);
        break;
    case DataProcessor::MEGASQUIRT_ID:
        updateMegasquirt(data);
        break;
    case DataProcessor::CURRENT_ID:
        updateCurrent(data);
        break;
    case DataProcessor::VOLTAGE_ID:
        updateVoltage(data);
        break;
    default:
        break;// Do nothing if the CAN frame does not have an ID that we care about
    }
}

void DataProcessor::updateGroundSpeed(QByteArray data)
{
    int wheelRotationFrequency = data[1];

    // Declare a wheel circumference and use to compute a proof-of-concept ground speed:
//    double wheelCircumferenceInFeet = 69.113;
//    double feetPerSecond = wheelRotationFrequency * wheelCircumferenceInFeet;
//    const int SECONDS_PER_HOUR = 3600;
//    const int FEET_PER_MILE = 5280;
//    qreal milesPerHour = (feetPerSecond / FEET_PER_MILE) * SECONDS_PER_HOUR;

    raceDataset->setGroundSpeed(wheelRotationFrequency);
    raceDataset->groundSpeedNotify();

    // These two lines don't really belong here, they are just to demonstrate
    // that the updateGroundSpeed function is running.
//    raceDataset->setSpeedSensorStatus(true);
//    raceDataset->speedSensorStatusNotify();

    qDebug() << "Wheel frequency: " << wheelRotationFrequency << "\n";
}

void DataProcessor::updateAirSpeed(QByteArray data)
{

}

void DataProcessor::updateEFIPressure(QByteArray data)
{

}

void DataProcessor::updateMegasquirt(QByteArray data)
{

}

void DataProcessor::updateCurrent(QByteArray data)
{

}

void DataProcessor::updateVoltage(QByteArray data)
{

}

/*void DataProcessor::updateInterfaceIndicators(QByteArray data)
{

}*/
