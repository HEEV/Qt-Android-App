#include "DataProcessor.h"
#include <climits>


// This signal gives the number of wheel rotations since
//   the last message (resets to 0 every second)
const int DataProcessor::TACHOMETER_PULSES_ID = 1150;
// This signal gives the time interval of the most recent wheel rotation
const int DataProcessor::TACHOMETER_TIME_LAST_PULSE_ID = 1154;
const int DataProcessor::PITOT_ID = 950;
const int DataProcessor::EFI_PRESSURE_ID = 1;
const int DataProcessor::MEGASQUIRT_ID = 2;
const int DataProcessor::CURRENT_ID = 3;
const int DataProcessor::VOLTAGE_ID = 4;
const uint32_t DataProcessor::NO_NEW_DATA = 0xFFFFFFFF;
const int DataProcessor::WHEEL_TIMEOUT_LENGTH = 6000;

const double DataProcessor::VELOCITY_MULTIPLIER_BASE = 56.8181818181;
const double DataProcessor::URBIE_WHEEL_CIRCUMFERENCE = 67.937;
const double DataProcessor::STING_WHEEL_CIRCUMFERENCE = 60.868;

DataProcessor::DataProcessor(UIRaceDataset *uiRaceDataset, QString carName, Logger *log)
{
    this->raceDataset = uiRaceDataset;
    logger = log;
    // Calculate the velocity multiplier for ground speed
    if(carName != "Urbie" & carName != "Sting")
    {
        carName = "Urbie";
    }
    setWheelCircumference(carName);
}

void DataProcessor::setWheelCircumference(QString carName)
{
    if (carName == QString("Urbie"))
    {
        velocityMultiplier = VELOCITY_MULTIPLIER_BASE * URBIE_WHEEL_CIRCUMFERENCE;
    }
    else if (carName == QString("Sting"))
    {
        velocityMultiplier = VELOCITY_MULTIPLIER_BASE * STING_WHEEL_CIRCUMFERENCE;
    }
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

/*!
 * \brief DataProcessor::updateGroundSpeed calculates and sets the
 * ground speed based on how long it took the wheel to revolve
 * \param data the message data from the CANInterface
 */
void DataProcessor::updateGroundSpeed(QByteArray data)
{
    static time_t currentTime = 0;
    currentTime = time(nullptr);
    qreal milesPerHour = 0;

     // Grab the time interval from data byte 1.
    uint32_t intervalOfLastRevolution = NO_NEW_DATA;
    CanNodeParser::getData(data, intervalOfLastRevolution);

    // If we got a max_int (meaning CAN board did not receive a pulse since last message)
    if (intervalOfLastRevolution == NO_NEW_DATA)
    {
        // the time that has elapsed since we last processed a new revolution interval
        int timeSinceLastUpdate = timeDifferenceInMilliseconds(currentTime, timeOfLastWheelPulseMessage);

        if (timeSinceLastUpdate > WHEEL_TIMEOUT_LENGTH)
        {
            // Set the ground speed as if it the car has stopped.
            milesPerHour = 0.0;
        }
        else
        {
            // Stop now and don't update the speed  since it has not been
            // long enough to assume that the has stopped
            return;
        }
    }
    else
    {
        // Save the current time
        timeOfLastWheelPulseMessage = currentTime;
        intervalOfLastKnownRevolution = intervalOfLastRevolution;

        // Calculate the velocity
        milesPerHour = calculateMPH(intervalOfLastRevolution);
        //logger->println("Speed: " + QString::number(milesPerHour).toStdString());

        updateAverageSpeed(milesPerHour);
    }

    raceDataset->setGroundSpeed(milesPerHour);
    raceDataset->groundSpeedNotify();
}

void DataProcessor::updateAverageSpeed(qreal currentSpeed)
{
    static qreal numerator = 0;
    static qreal denominator = 1;
    static bool firstValue = true;

    if(!firstValue)
    {
        numerator += currentSpeed;
        qreal average = numerator/(++denominator);
        raceDataset->setAverageSpeed(QString::number(average, 'f', 1));
        raceDataset->averageSpeedNotify();
    }
    else
    {
        numerator += currentSpeed;
        raceDataset->setAverageSpeed(QString::number(currentSpeed, 'f', 1));
        raceDataset->averageSpeedNotify();
    }
}

qreal DataProcessor::calculateMPH(uint32_t revolutionInterval)
{
    return (qreal)((1.0 / (double)revolutionInterval) * velocityMultiplier);
}

int DataProcessor::timeDifferenceInMilliseconds(time_t endTime, time_t startTime)
{
    return (int)(difftime(endTime, startTime) * 1000.0);
}

void DataProcessor::updateAirSpeed(QByteArray data)
{
    //voltage -> pressure;
    uint16_t voltage;
    CanNodeParser::getData(data, voltage);
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

//    logger->println("Wind value: " + QString::number(windSpeed).toStdString());
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
