#ifndef DATAPROCESSOR_H
#define DATAPROCESSOR_H

#include <QCanBusFrame>
#include <UIRaceDataset.h>
#include <QDebug>
#include "CanNodeParser.h"
#include "Logger.h"

class DataProcessor
{
public:
    DataProcessor(UIRaceDataset *uiRaceDataSet, QString carName, Logger *log);

    void setWheelCircumference(QString carName);

    void routeCANFrame(QCanBusFrame frame);

    // Setters for values that come from CANInterface
    void updateGroundSpeed(QByteArray data);
    void updateAverageSpeed();
    void updateAirSpeed(QByteArray data);
    void updateEFIPressure(QByteArray data);
    void updateMegasquirt(QByteArray data);
    void updateCurrent(QByteArray data);
    void updateVoltage(QByteArray data);

private:
    // CAN frame ids. These numbers have not been finalized or verified.
    static const int TACHOMETER_PULSES_ID;
    static const int TACHOMETER_TIME_LAST_PULSE_ID; // Used for ground speed
    static const int PITOT_ID; // Used for air speed
    static const int EFI_PRESSURE_ID; // Used for fuel injection info
    static const int MEGASQUIRT_ID; // Used for engine temperature and other info
    static const int CURRENT_ID;
    static const int VOLTAGE_ID;

    // the value received when a sensor sends a message that
    // does not contain new information
    static const uint32_t NO_NEW_DATA;

    // the amount of time (in milliseconds) to wait for new
    // data from the wheel tachometer before assuming the car
    // has (basically) stopped.
    static const int WHEEL_TIMEOUT_LENGTH;

    // Multiplier to get velocity from revolutions per second
    static const double VELOCITY_MULTIPLIER_BASE;
    double velocityMultiplier;

    static const double URBIE_WHEEL_CIRCUMFERENCE;
    static const double STING_WHEEL_CIRCUMFERENCE;

    // Holds the time of the last tachometer message that
    // included a *new* wheel time interval (i.e. a message
    // whose value was NOT INT_MAX
    time_t timeOfLastWheelPulseMessage;
    // Time in seconds that it took for the wheel to go around
    // for the most recent full revolution
    uint32_t intervalOfLastKnownRevolution;

    // Helper methods for updateGroundSpeed()
    qreal calculateMPH(uint32_t revolutionInterval);
    int timeDifferenceInMilliseconds(time_t startTime, time_t endTime);

    UIRaceDataset *raceDataset;
    Logger *logger;
};

#endif // DATAPROCESSOR_H
