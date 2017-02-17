#include "DataProcessor.h"

//1154 for time between pulses.
//1150 for pulses per second.

// This signal gives the number of wheel rotations since
//   the last message (resets to 0 every second)
const int DataProcessor::TACHOMETER_PULSES_ID = 1150;
// This signal gives the time interval of the most recent wheel rotation
const int DataProcessor::TACHOMETER_TIME_LAST_PULSE_ID = 1154;
const int DataProcessor::PITOT_ID = 1648;
const int DataProcessor::EFI_PRESSURE_ID = 1;
const int DataProcessor::MEGASQUIRT_ID = 2;
const int DataProcessor::CURRENT_ID = 3;
const int DataProcessor::VOLTAGE_ID = 4;

const double DataProcessor::VELOCITY_MULTIPLIER_BASE = 56.8181818181;

DataProcessor::DataProcessor(UIRaceDataset *uiRaceDataset, double inchesPerWheelRevolution)
{
    this->raceDataset = uiRaceDataset;

    // Calculate the velocity multiplier for ground speed
    velocityMultiplier = VELOCITY_MULTIPLIER_BASE * inchesPerWheelRevolution;
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
    case DataProcessor::TACHOMETER_TIME_LAST_PULSE_ID:
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
    // Grab the time interval from data byte 1.
    uint32_t intervalOfLastRevolution =
            data[1]
            | (data[2] << 8)
            | (data[3] << 16)
            | (data[4] << 24);

    // Declare a wheel circumference and use to compute a proof-of-concept ground speed:
    qreal milesPerHour = (qreal)((1.0 / (double)intervalOfLastRevolution) * velocityMultiplier);

    raceDataset->setGroundSpeed(milesPerHour);
    raceDataset->groundSpeedNotify();

    // These two lines don't really belong here, they are just to demonstrate
    // that the updateGroundSpeed function is running.
//    raceDataset->setSpeedSensorStatus(true);
//    raceDataset->speedSensorStatusNotify();

    //qDebug() << "Wheel frequency: " << wheelRotationFrequency << "\n";
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
