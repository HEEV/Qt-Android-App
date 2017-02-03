#ifndef DATAPROCESSOR_H
#define DATAPROCESSOR_H

#include <QCanBusFrame>



class DataProcessor
{
public:
    DataProcessor();

    void routeCANFrame(QCanBusFrame frame);

    // Setters for values that come from CANInterface
    void updateGroundSpeed(QByteArray data);
    void updateAirSpeed(QByteArray data);
    void updateEFIPressure(QByteArray data);
    void updateMegasquirt(QByteArray data);
    void updateCurrent(QByteArray data);
    void updateVoltage(QByteArray data);

private:
    // CAN frame ids. These numbers have not been finalized or verified.
    int const TACHOMETER_ID = 1584; // Used for ground speed
    int const PITOT_ID = 1648; // Used for air speed
    int const EFI_PRESSURE_ID = 0; // Used for fuel injection info
    int const MEGASQUIRT_ID = 0; // Used for engine temperature and other info
    int const CURRENT_ID = 0;
    int const VOLTAGE_ID = 0;
};

#endif // DATAPROCESSOR_H
