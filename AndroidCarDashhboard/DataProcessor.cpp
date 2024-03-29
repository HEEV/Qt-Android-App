#include "DataProcessor.h"
#include <climits>
#include <time.h>
#include <cmath>


// This signal gives the number of wheel rotations since
//   the last message (resets to 0 every second)
const int DataProcessor::TACHOMETER_PULSES_ID = 1150;
// This signal gives the time interval of the most recent wheel rotation
const int DataProcessor::TACHOMETER_TIME_LAST_PULSE_ID = 1154;
const int DataProcessor::PITOT_ID = 950;
const int DataProcessor::EFI_PRESSURE_ID = 1;
const int DataProcessor::MEGASQUIRT_BASE_ID = 1512;
const int DataProcessor::CURRENT_ID = 3;
const int DataProcessor::VOLTAGE_ID = 4;
const uint32_t DataProcessor::NO_NEW_DATA = 0xFFFFFFFF;
const int DataProcessor::WHEEL_TIMEOUT_LENGTH = 5000;

const double DataProcessor::VELOCITY_MULTIPLIER_BASE = 56.8181818181;
const double DataProcessor::URBIE_WHEEL_CIRCUMFERENCE = 67.937;
const double DataProcessor::STING_WHEEL_CIRCUMFERENCE = 60.868;

bool   DataProcessor::initialAverage = true;

DataProcessor::DataProcessor(UIRaceDataset *uiRaceDataset, QString carName, Logger *log)
{
    this->raceDataset = uiRaceDataset;
    logger = log;
    // Calculate the velocity multiplier for ground speed
    if((carName != "Urbie") & (carName != "Sting"))
    {
        carName = "Sting";
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

void DataProcessor::routeCANFrame(can_frame frame)
{
    //If we get a CAN frame we should say that CAN is working.
    if(raceDataset->getCanStatus() == false)
    {
        raceDataset->setCanStatus(true);
        raceDataset->canStatusNotify();
    }

    int id = frame.can_id;
    QByteArray data = (char *) frame.data;
    while(data.length() != frame.can_dlc)
    {
        data.append('\0');
    }

    // For efficienty, these cases should be ordered with the most
    // frequent ids at the top.
    switch(id)
    {
    case DataProcessor::TACHOMETER_TIME_LAST_PULSE_ID:
        if (!(raceDataset->getUseGPSSpeed()))
        {
            updateGroundSpeed(data);
        }
        break;
    case DataProcessor::PITOT_ID:
        updateAirSpeed(data);
        break;
    case DataProcessor::EFI_PRESSURE_ID:
        updateEFIPressure(data);
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

    //Megasqurt has a range of ID's and it is sensor data so it can come after everything else.
    if(id >= DataProcessor::MEGASQUIRT_BASE_ID || id <= (DataProcessor::MEGASQUIRT_BASE_ID+4))
    {
        updateMegasquirt(id, frame);
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
    static qreal milesPerHour = 0;

     // Grab the time interval from data byte 1.
    uint32_t intervalOfLastRevolution = NO_NEW_DATA;
    CanNodeParser::getData_uint32(data, intervalOfLastRevolution);

    // If we got a max_int (meaning CAN board did not receive a pulse since last message)
    if (intervalOfLastRevolution == NO_NEW_DATA)
    {
        // the time that has elapsed since we last processed a new revolution interval
        int timeSinceLastUpdate = timeDifferenceInMilliseconds(currentTime, timeOfLastWheelPulseMessage);

        if (timeSinceLastUpdate > WHEEL_TIMEOUT_LENGTH)
        {
            // Set the ground speed as if the car has stopped.
            milesPerHour = 0.0;
        }
//        else
//        {
//            // Stop now and don't update the speed  since it has not been
//            // long enough to assume that the has stopped
//            return;
//        }
    }
    else
    {
        // Save the current time
        timeOfLastWheelPulseMessage = currentTime;
        intervalOfLastKnownRevolution = intervalOfLastRevolution;

        // Calculate the velocity
        milesPerHour = calculateMPH(intervalOfLastRevolution);
        //logger->println("Speed: " + QString::number(milesPerHour).toStdString());

        }
    //logger->println("Current speed: " + QString::number(milesPerHour) + "\n");
    raceDataset->setGroundSpeed(milesPerHour);
    raceDataset->groundSpeedNotify();
}

void DataProcessor::initiateAverageSpeed()
{
    initialAverage = true;
}

void DataProcessor::updateAverageSpeed()
{
    qreal currentSpeed = raceDataset->getGroundSpeed();
    static qreal numerator = 0;
    static qreal denominator = 1;

    if(!initialAverage)
    {
        numerator += currentSpeed;
        qreal average = numerator/(++denominator);
        raceDataset->setAverageSpeed(QString::number(average, 'f', 1));
        raceDataset->averageSpeedNotify();
    }
    else
    {
        numerator = 0;
        denominator = 1;
        initialAverage = false;
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
	
	//constants
	//measureable constants
    const float rho = 1.225; //A good value for rho. Rho Rho your boat gently down the I/O stream.
	const float vcc = 3.6; // Presure sensor supply voltage.
    const float speedConversionFactor = 2.2369;// Converts m/s to miles per hour.

    //calibration constants (derived from actual data!!!)
	const float scalingFactor1 = 0.81081;
	const float scalingFactor2 = 1.41430;
	const float offset1 = 0.26;

	//convert the CAN data into a voltage (in mili-volts)
    uint16_t voltage;
    CanNodeParser::getData_uint16(data, voltage);

	//voltage -> pressure;
	double pressure;
	// convert the voltage to pressure (sorry for the magic numbers)
	pressure = scalingFactor1*(voltage/vcc) - 400.0f; 

	// we don't want a value less than 0 (will mess up the sqrt)
	if(pressure<0.0f){
		pressure=0.0f;
	}
	//pressure -> wind speed (mph)
	double windSpeed;
	// bernouli's eqn (pressure -> wind speed (m/s) 
	windSpeed = scalingFactor2 * sqrt((2 * pressure)/ rho); 
	//convert m/s into mi/hr
	windSpeed *= speedConversionFactor; 
	//apply one more calibration constant
	windSpeed += offset1;

	//We are done! Wasn't that fun!?!
    raceDataset->setWindSpeed(windSpeed);
    qDebug() << "This is the wind speed. " << QString::number(windSpeed) << "\n";
}

void DataProcessor::updateEFIPressure(QByteArray data)
{

}


void DataProcessor::updateMegasquirt(int id, can_frame frame)
{
    QString loggerStr = "";
    if(id == DataProcessor::MEGASQUIRT_BASE_ID)
    {
        //QByteArray temp = data.mid(2,2);
        int engineRPM = (int)frame.data[2] << 8;
        engineRPM |= (int)frame.data[3];
        raceDataset->setEngineRPM(engineRPM);
        raceDataset->engineRPMNotify();
        loggerStr = "EngineRPM: ";
        loggerStr += QString::number(engineRPM);
        loggerStr += " RPM\n";

        int coolantTemp = frame.data[4] << 8;
        coolantTemp |= frame.data[5];
        float fCoolantTemp = (float)coolantTemp / 10.0f;
        raceDataset->setCoolantTemp(fCoolantTemp);
        raceDataset->coolantTempNotify();
        loggerStr += "CoolantTemp: ";
        loggerStr += QString::number(fCoolantTemp);
        loggerStr += " C\n";

        int throttlePos = frame.data[6] << 8;
        throttlePos |= frame.data[7];
        float fThrottlePos = (float)throttlePos / 10.0f;
        raceDataset->setThrottlePos(fThrottlePos);
        raceDataset->throttlePosNotify();
        loggerStr += "ThrottlePos: ";
        loggerStr += QString::number(fThrottlePos);
        loggerStr += "\n";
    }
    else if(id == DataProcessor::MEGASQUIRT_BASE_ID + 1)
    {
        int manifoldAirTemperature = frame.data[4] << 8;
        manifoldAirTemperature |= frame.data[5];
        float fManifoldAirTemperature = (float)manifoldAirTemperature / 10.0f;
        raceDataset->setManifoldAirTemp(fManifoldAirTemperature);
        raceDataset->manifoldAirTempNotify();
        loggerStr += "ManifoldAirTemp: ";
        loggerStr += QString::number(fManifoldAirTemperature);
        loggerStr += " C\n";
    }
    else if(id == DataProcessor::MEGASQUIRT_BASE_ID + 3)
    {
        int batteryVoltage = frame.data[0] << 8;
        batteryVoltage |= frame.data[1];
        float fBatteryVoltage = (float)batteryVoltage / 10.0f;
        raceDataset->setBatteryVoltage(fBatteryVoltage);
        raceDataset->batteryVoltageNotify();
        loggerStr += "BatteryVoltage: ";
        loggerStr += QString::number(fBatteryVoltage);
        loggerStr += "\n";
    }
    logger->println(loggerStr);
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
