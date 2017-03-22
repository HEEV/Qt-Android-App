#include "DataProcessor.h"
#include <climits>


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
    logger = new Logger();
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
    const uint32_t WHEEL_STOPPED = 0xFFFFFFFF;
    time_t currentTime = time(nullptr);

    qreal milesPerHour = 0;

     // Grab the time interval from data byte 1.
    uint32_t intervalOfLastRevolution = WHEEL_STOPPED;
    //get the data
    CanNodeParser::getData(data, intervalOfLastRevolution);

    // If we got a max_int (meaning CAN board did not receive a pulse since last message
    if (intervalOfLastRevolution == WHEEL_STOPPED)
    {
        // the time that has elapsed since we last processed a new revolution interval
        uint32_t timeSinceLastUpdate = (uint32_t)(difftime(currentTime, timeOfLastWheelPulseMessage) * 1000.0);
        // if time since last updateGroundSpeed is greater than last known wheel rotation interval
        if (timeSinceLastUpdate > intervalOfLastKnownRevolution)
        {
            // Calculate the velocity based on an estimated interval
            milesPerHour = calculateMPH(timeSinceLastUpdate);
        }
        else
        {
            // Stop now and don't update the speed
            // since it has not been long enough to
            // assume deceleration has occurred.
            return;
        }
        qDebug << "Time since last update: " << timeSinceLastUpdate << "\n";
    }
    else
    {
        // Save the current time
        timeOfLastWheelPulseMessage = currentTime;
        intervalOfLastKnownRevolution = intervalOfLastRevolution;

        // Calculate the velocity
        milesPerHour = calculateMPH(intervalOfLastRevolution);

        qDebug << "Wheel revolution time: " << intervalOfLastRevolution << "\n";
    }


    raceDataset->setGroundSpeed(milesPerHour);
    raceDataset->groundSpeedNotify();

    // These two lines don't really belong here, they are just to demonstrate
    // that the updateGroundSpeed function is running.
//    raceDataset->setSpeedSensorStatus(true);
//    raceDataset->speedSensorStatusNotify();

    //qDebug() << "Wheel frequency: " << wheelRotationFrequency << "\n";
}

qreal DataProcessor::calculateMPH(uint32_t revolutionInterval)
{
    return (qreal)((1.0 / (double)revolutionInterval) * velocityMultiplier);
}

void DataProcessor::updateAirSpeed(QByteArray data)
{
    //voltage -> pressure;
    uint16_t voltage;
    CanNodeParser::getData(data, voltge);
    double pressure;
    float vcc = 3.6; // Presure sensor supply voltage.
    float scalingFactor1 = 0.81081;
    float voltageMath = voltage;
    voltageMath /= 1000.0f;
    voltageMath *= scalingFactor1;
    pressure = (((voltage * 10.0f)/vcc) - 4.0f) * 100.0f;

    float rho = 1.225; //A good value for rho.
    float scalingFactor2 = 1.41430;
    float offset1 = -0.26;
    double windSpeed;
    windSpeed = sqrt((2 * pressure)/ rho); // In m/s
    windSpeed *= 2.2369;
    windSpeed *= scalingFactor2;
    windSpeed += offset1;
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
